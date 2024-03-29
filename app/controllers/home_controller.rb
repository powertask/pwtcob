 class HomeController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js, :json

  layout 'application'

  def index
  	session[:unit_id] = current_user.unit.id
  	session[:unit_name] = current_user.unit.name
    session[:unit_bank_billet_account] = 21
    session[:taxpayer_id] = nil

    if current_user.profile == 'client'
      session[:client_id] = 1
      session[:client_name] = 'FAESC'
    end

    if session[:client_id].nil?
      redirect_to(controller: :clients, action: :get_client)  and return
    end
    
    contracts_meter
  end


  def filter_name
    
    if params[:filter][:name].present?

      if params[:filter][:name].size < 3
        flash[:alert] = "Nome do contribuinte deve conter ao menos 3 letras."
        redirect_to :root and return
      end 

      @taxpayers = Taxpayer
                    .joins(:city)
                    .where("taxpayers.unit_id = ? AND taxpayers.client_id = ? AND lower(taxpayers.name) like ?", current_user.unit_id, session[:client_id], "%"<< params[:filter][:name].downcase << "%")
                    .paginate(:page => params[:page], :per_page => 5)
                    .order('name ASC')

    elsif params[:filter][:cpf].present?

      unless params[:filter][:cpf].size == 14
        flash[:alert] = "CPF deve conter 11 números no formato 999.999.999-99"
        redirect_to :root and return
      end 

      @taxpayers = Taxpayer
                    .joins(:city)
                    .where("taxpayers.unit_id = ? AND taxpayers.client_id = ? AND taxpayers.cpf = ?", current_user.unit_id, session[:client_id], params[:filter][:cpf])
                    .paginate(:page => params[:page], :per_page => 5)
                    .order('name ASC')

    elsif params[:filter][:cna].present?

      @taxpayers = Taxpayer
                    .where("unit_id = ? AND origin_code = ?", current_user.unit_id, params[:filter][:cna])
                    .paginate(:page => params[:page], :per_page => 5)
                    .order('name ASC')

    else

      flash[:alert] = "Nenhum filtro preenchido."
      redirect_to :root and return
    end 

    if @taxpayers.count == 0
      flash[:alert] = "Não encontrado contribuinte."
      redirect_to :root and return
    end 

    contracts_meter

    render "index", :layout => 'application'
  end


  def show
    @taxpayer = Taxpayer.find(params[:cod])

    unless current_user.admin?
     if @taxpayer.user_id != current_user.id
       flash[:alert] = "Contribuinte não pertence a sua lista."
       redirect_to :root and return
     end 
    end

    @contacts = TaxpayerContact.where('taxpayer_id = ?', params[:cod])

    @cnas_negotiables = Cna.list(current_user.unit_id, session[:client_id]).where('taxpayer_id = ? AND status = 0 AND stage = 1', params[:cod]).order(:year, :due_at)
    @cnas_lawyers = Cna.list(current_user.unit_id, session[:client_id]).where('taxpayer_id = ? AND stage = 0', params[:cod]).order(:year, :due_at)
    @cnas_not_negotiables = Cna.list(current_user.unit_id, session[:client_id]).where('taxpayer_id = ? AND status in (1,2,3) AND stage = 1', params[:cod]).order(:year)

    @contracts_for_taxpayer = Contract.list(current_user.unit_id, session[:client_id]).where('taxpayer_id = ?', params[:cod])
    
    clear_variable_session()
    contracts_meter

    @histories = History.list(current_user.unit_id, session[:client_id]).where('taxpayer_id = ?', params[:cod]).order('created_at DESC')

    session[:taxpayer_id] = params[:cod]

    render "index", :layout => 'application'
  end



  def deal

    if params[:date_current].nil?
      @date_current = Date.current
    else
      @date_current = Date.new(params[:date_current][:year].to_i, params[:date_current][:month].to_i, params[:date_current][:day].to_i)
    end

    if params[:data_base].present? && params[:data_base][:date_current].present?
      @date_current = params[:data_base][:date_current].to_date
    else
      @date_current = Date.current
    end

    if @date_current < Date.current
      flash[:alert] = "Data base não pode ser menor que data atual"
      @date_current = nil
      redirect_to deal_path(params[:cod]) and return 
    end

    if current_user.client?
      flash[:alert] = "Não permitido acessar Ambiente de Negociações!"
      redirect_to show_path(params[:cod]) and return 
    end

    @taxpayer = Taxpayer.find(params[:cod])

    unless current_user.admin?
      if @taxpayer.user_id != current_user.id
        flash[:alert] = "Contribuinte não pertence a sua lista."
        redirect_to :root and return
      end
    end
 
    unless Taxpayer.chargeble? @taxpayer
      flash[:alert] = "Cidade não liberada para negociações!"
      redirect_to show_path(params[:cod]) and return 
    end

    @contacts = TaxpayerContact.where('taxpayer_id = ?', params[:cod])

    @areas = Area.list(current_user.unit_id).where('taxpayer_id = ?', params[:cod]).order('year DESC, nr_document')
    @histories = History.list(current_user.unit_id, session[:client_id]).where('taxpayer_id = ?', params[:cod]).order('created_at DESC')

    @contract = Contract.new
    @contract.unit_ticket_quantity = 1
    @contract.client_ticket_quantity = 1

    @cnas = Cna.list(current_user.unit_id, session[:client_id]).not_pay.normal.where('taxpayer_id = ?', params[:cod]).order(:year, :due_at)
    @cna = Cna.new

    clear_variable_session()

    respond_with @taxpayer, :layout => 'application'     
  end


  def get_cna
    @cna = Cna.find(params[:cod])
  end

  
  def set_cna
    @cna = Cna.find(params[:cod])
    @cna.update_attributes(cna_params)

    @cnas = Cna.list(current_user.unit_id, session[:client_id]).not_pay.where('taxpayer_id = ?', @cna.taxpayer.id).order(:year)
    @taxpayer = Taxpayer.find @cna.taxpayer.id

    if params[:date_current].nil?
      @date_current = Date.current
    else
      @date_current = Date.new(params[:date_current][:year].to_i, params[:date_current][:month].to_i, params[:date_current][:day].to_i)
    end
    
    clear_variable_session()

  end


  def set_charge_cna
    @cna = Cna.find(params[:cod])
    @cna.fl_charge = @cna.fl_charge == true ? false : true
    @cna.save!

    @cnas = Cna.list(current_user.unit_id, session[:client_id]).not_pay.normal.where('taxpayer_id = ?', @cna.taxpayer.id).order(:year)
    @taxpayer = Taxpayer.find @cna.taxpayer.id

    if params[:date_current].nil?
      @date_current = Date.current
    else
      @date_current = Date.new(params[:date_current][:year].to_i, params[:date_current][:month].to_i, params[:date_current][:day].to_i)
    end
    clear_variable_session()
  end


  def set_lawyer_to_cna

    begin
      ActiveRecord::Base.transaction do

        @cna = Cna.find(params[:cod])
        @cna.stage = @cna.normal? ? :lawyer : :normal
        @cna.fl_charge = false
        @cna.save!

        history = History.new
        history.unit_id = current_user.unit_id
        history.client_id = @cna.client_id
        history.taxpayer_id = @cna.taxpayer_id
        history.user_id = current_user.id
        history.word_id = 4 ## Ajuizado
        history.history_date = Time.current
        history.description = 'CNA referente ' + @cna.year.to_s + ' marcada para AJUIZAR.'
        history.save!      

      end
      rescue ActiveRecord::RecordInvalid => e
      puts e.record.errors.full_messages
    end  

    @cnas = Cna.list(current_user.unit_id, session[:client_id]).not_pay.normal.where('taxpayer_id = ?', @cna.taxpayer.id).order(:year)
    @taxpayer = Taxpayer.find @cna.taxpayer.id

    if params[:date_current].nil?
      @date_current = Date.current
    else
      @date_current = Date.new(params[:date_current][:year].to_i, params[:date_current][:month].to_i, params[:date_current][:day].to_i)
    end
    clear_variable_session()
  end


  def pay_cna
    if current_user.id == 1
      @cna = Cna.find(params[:cod])
      @cna.pay!

      redirect_to show_path(@cna.taxpayer_id) and return
    end
  end


  def set_cna_to_normal
    if current_user.id == 1
      @cna = Cna.find(params[:cod])
      @cna.normal!

      redirect_to show_path(@cna.taxpayer_id) and return
    end
  end


  def get_tickets
    unit_ticket_quantity  =  params[:ticket][:unit_ticket_quantity].to_i
    unit_ticket_due       =  params[:ticket][:unit_ticket_due].to_date
    client_ticket_due     =  params[:ticket][:client_ticket_due].to_date

    if params[:ticket][:value_type].to_i == 0
      total_cna_a_vista = session[:total_cna_a_vista].to_f
      total_fee = session[:total_fee_a_vista].to_f.round(2)
      total_cna = total_cna_a_vista - total_fee      
    else
      total_cna_cobrado = session[:total_cna_cobrado].to_f
      total_fee = (session[:total_fee_cobrado].to_f).round(2)
      total_cna = total_cna_cobrado - total_fee      
    end

    cna_ticket = total_cna / unit_ticket_quantity.to_i
    @tickets = []

    unit_ticket_quantity  = unit_ticket_quantity + 1

    (1..unit_ticket_quantity).each  do |tic|
      unit_due = unit_ticket_due if tic == 1
      client_due = client_ticket_due if tic == 2
      client_due = client_ticket_due + (tic - 2).month if tic > 2

      ticket = { ticket: tic, unit_amount: total_fee, client_amount: 0.00, due: unit_due} if tic == 1
      ticket = { ticket: tic, unit_amount: 0.00, client_amount: cna_ticket.round(2), due: client_due} if tic > 1
      @tickets << ticket
      session[:tickets] = @tickets
    end
  end

  
  def get_taxpayer
    @taxpayer = Taxpayer.find(params[:cod])
  end

  def set_taxpayer
    @taxpayer = Taxpayer.find(params[:cod])
    @taxpayer.update_attributes(taxpayer_params)
  end



  private
  def cna_params
    params.require(:cna).permit(:fl_charge)
  end

  def taxpayer_params
    params.require(:taxpayer).permit(:phone)
  end

  def clear_variable_session
    session[:value_cna] = 0
    session[:total_multa] = 0
    session[:total_juros] = 0
    session[:total_correcao] = 0
    session[:total_cna] = 0

    session[:value_cna_cobrado] = 0
    session[:total_multa_cobrado] = 0
    session[:total_juros_cobrado] = 0
    session[:total_correcao_cobrado] = 0
    session[:total_cna_cobrado] = 0
    session[:total_cna_sem_fee_cobrado] = 0
    session[:total_fee_cobrado] = 0

    session[:value_cna_a_vista] = 0
    session[:total_multa_a_vista] = 0
    session[:total_juros_a_vista] = 0
    session[:total_correcao_a_vista] = 0
    session[:total_cna_sem_fee_a_vista] = 0
    session[:total_cna_a_vista] = 0
    session[:total_fee_a_vista] = 0

  end


  def contracts_meter 
    dt_ini = Date.new(Date.current.year, Date.current.month, 1).beginning_of_day
    dt_end = Date.current.end_of_day

    if current_user.admin?
      @count_contracts_deal_day   = Contract.list_not_cancel(current_user.unit_id, session[:client_id]).where('contract_date between ? AND ?', Date.current.beginning_of_day, Date.current.end_of_day).count
      @count_contracts_deal_month = Contract.list_not_cancel(current_user.unit_id, session[:client_id]).where('contract_date between ? AND ?', dt_ini, dt_end ).count
      @list_last_histories     = History.list(current_user.unit_id, session[:client_id]).where('history_date is not null').order('history_date DESC').limit(30)
      users = User.select(:id, :name).list(current_user.unit_id).where('id > 2')

    else
      @count_contracts_deal_day   = Contract.list_not_cancel(current_user.unit_id, session[:client_id] ).where('user_id = ? AND contract_date between ? AND ?', current_user.id, Date.current.beginning_of_day, Date.current.end_of_day).count
      @count_contracts_deal_month = Contract.list_not_cancel(current_user.unit_id, session[:client_id] ).where('user_id = ? and contract_date between ? AND ?', current_user.id, dt_ini, dt_end ).count
      @list_last_histories     = History.list(current_user.unit_id, session[:client_id] ).where('user_id = ? AND history_date is not null', current_user.id).order('history_date DESC').limit(30) if current_user.user?
      users = User.select(:id, :name).list(current_user.unit_id).where('id = ?', current_user.id)
    end

    @resume_all = Array.new
    users.each do |user|
      taxpayers_count = Taxpayer.joins(:city).where("taxpayers.unit_id = ? and taxpayers.client_id = ? and taxpayers.user_id = ? and cities.fl_charge = ? ", current_user.unit_id, session[:client_id], user.id, true).count
      taxpayers_histories = History.where('unit_id = ? and client_id = ? and user_id = ? and history_date between ? and ?', current_user.unit_id, session[:client_id], user.id, Date.current.beginning_of_day, Date.current.end_of_day).group(:user_id, :taxpayer_id).order(:user_id).count.count
      cnas_amount_total = Cna.find_by_sql(['select sum(amount) amount from taxpayers t, cnas c, cities ct where t.unit_id = ? and t.user_id = ? and t.client_id = ? and t.id = c.taxpayer_id and t.city_id = ct.id and ct.fl_charge = ? and c.status = 0 and c.stage = 1', current_user.unit_id, user.id, session[:client_id], true])

      resume = Hash.new
      resume[:user_id] = user.id
      resume[:user_name] = user.name
      resume[:taxpayers_count] = taxpayers_count
      resume[:taxpayers_histories] = taxpayers_histories
      resume[:cnas_amount_total] = cnas_amount_total[0][:amount].real
      @resume_all.push(resume)
    end
    @resume_all.sort_by!{|e| -e[:taxpayers_histories]}


    if current_user.admin?
      @count_contracts_deal_day_for_users = Contract.list(current_user.unit_id, session[:client_id]).active.where('contract_date between ? AND ?', Date.current.beginning_of_day, Date.current.end_of_day).group('user_id').count
      @count_contracts_deal_month_for_users = Contract.find_by_sql(['select u.id, u.name, count(1) contract_count from contracts c, users u where c.user_id = u.id AND c.unit_id = ? AND client_id = ? AND contract_date between ? AND ? AND status in (0,2) group by u.id, u.name order by contract_count DESC', current_user.unit_id, session[:client_id], dt_ini, dt_end])
      @list_last_contracts = Contract.list(current_user.unit_id, session[:client_id]).where('status in (0,2)').order('contract_date DESC').limit(5)
    else
      @count_contracts_deal_day_for_users = Contract.list(current_user.unit_id, session[:client_id] ).active.where('user_id = ? AND contract_date between ? AND ?', current_user.id, Date.current.beginning_of_day, Date.current.end_of_day).group('user_id').count
      @count_contracts_deal_month_for_users = Contract.find_by_sql(['select u.id, u.name, count(1) contract_count from contracts c, users u where c.user_id = ? AND c.user_id = u.id AND c.unit_id = ? AND client_id = ? AND contract_date between ? AND ? AND status in (0,2) group by u.id, u.name order by contract_count DESC', current_user.id, current_user.unit_id, session[:client_id], dt_ini, dt_end])
      @list_last_contracts = Contract.list(current_user.unit_id, session[:client_id]).where('user_id = ? AND status in (0,2)', current_user.id).order('contract_date DESC').limit(5)
    end      

    @count_contracts_deal_day_for_users = @count_contracts_deal_day_for_users.map{|z|z}

    dt_base = Date.current - 30.days

    if current_user.admin?
      @list_taxpayers_in_debt_without_histories_last_30_days = 
        Taxpayer.paginate_by_sql(['select t.id, t.name, sum(c.amount) amount, ' +
                                      "'' last_history " +
                                  'from cnas c, taxpayers t, cities ct ' +
                                  'where c.taxpayer_id = t.id ' +
                                  'AND t.client_id = ? ' +
                                  'AND t.city_id = ct.id ' +
                                  'AND c.status = 0 ' +
                                  'AND c.stage = 1 ' +
                                  'AND ct.fl_charge = ? ' +
                                  'AND exists(select 1 from histories h where h.taxpayer_id = t.id) ' +
                                  'AND not exists(select 1 from histories h where h.taxpayer_id = t.id AND history_date > ?) ' +
                                  'group by t.id, t.name ' +
                                  'order by 3 DESC', session[:client_id], true, dt_base], :page => params[:page], :per_page => 10)

      @list_taxpayers_in_debt_without_histories = 
        Taxpayer.paginate_by_sql(['select t.id, t.name, sum(c.amount) amount ' +
                                  'from cnas c, taxpayers t, cities ct ' +
                                  'where c.taxpayer_id = t.id  ' +
                                  'AND t.client_id = ? ' +
                                  'AND t.city_id = ct.id  ' +
                                  'AND c.status = 0 ' +
                                  'AND c.stage = 1 ' +
                                  'AND ct.fl_charge = ? ' +
                                  'AND not exists(select 1 from histories h where h.taxpayer_id = t.id) ' +
                                  'group by t.id, t.name ' +
                                  'order by 3 DESC', session[:client_id], true], :page => params[:page], :per_page => 15)

    else
      @list_taxpayers_in_debt_without_histories_last_30_days = 
        Taxpayer.paginate_by_sql(['select t.id, t.name, sum(c.amount) amount, ' +
                                          "'' last_history " +
                                  'from cnas c, taxpayers t, cities ct ' +
                                  'where c.taxpayer_id = t.id  ' +
                                  'AND t.user_id = ? ' +
                                  'AND t.client_id = ? ' +
                                  'AND t.city_id = ct.id  ' +
                                  'AND c.status = 0 ' +
                                  'AND c.stage = 1 ' +
                                  'AND ct.fl_charge = ? ' +
                                  'AND exists(select 1 from histories h where h.taxpayer_id = t.id) ' +
                                  'AND not exists(select 1 from histories h where h.taxpayer_id = t.id AND history_date > ?) ' +
                                  'group by t.id, t.name ' +
                                  'order by 3 DESC', current_user.id, session[:client_id], true, dt_base], :page => params[:page], :per_page => 10)

      @list_taxpayers_in_debt_without_histories = 
        Taxpayer.paginate_by_sql(['select t.id, t.name, sum(c.amount) amount ' +
                                  'from cnas c, taxpayers t, cities ct ' +
                                  'where c.taxpayer_id = t.id  ' +
                                  'AND t.user_id = ? ' +
                                  'AND t.client_id = ? ' +
                                  'AND t.city_id = ct.id  ' +
                                  'AND c.status = 0 ' +
                                  'AND c.stage = 1 ' +
                                  'AND ct.fl_charge = ? ' +
                                  'AND not exists(select 1 from histories h where h.taxpayer_id = t.id) ' +
                                  'group by t.id, t.name ' +
                                  'order by 3 DESC', current_user.id, session[:client_id], true], :page => params[:page], :per_page => 15)

    end

    @list_taxpayers_in_debt_without_histories_last_30_days.each do |taxpayer|
      history = History.where('taxpayer_id = ? AND history_date <= ?', taxpayer.id, dt_base).last
      if history.present?
        user = history.user ? history.user.name : 'N/D'
        taxpayer.last_history = user << ' em ' << history.history_date.to_s_br << ' - '  << history.description
      end
    end

  end
end
