module ApplicationHelper

  def calc_months(year)
  	date_base = Date.new(year, 5, 22)
  	date_today = Date.today()
  	(date_today.year * 12 + date_today.month) - (date_base.year * 12 + date_base.month)
  end

  def calc_multa(cna)
  	months = calc_months(cna.year)
    @value = cna.amount

    (1..months).map{|x|@value = @value + (x == 1 ? @value * 0.1 : @value * 0.02)}.last
    @value.round(2)
  end

  def calc_juros(cna)
    months = calc_months(cna.year)
    @value = cna.amount

    (1..months).map{|x|@value = @value + ( @value * 0.01 )}.last

    @value.round(2)
  end

  def calc_cna(cna)
    amount = cna.amount
    charge = 0

    multa = calc_multa(cna)
    juros = calc_juros(cna)
    total_cna = amount + multa + juros

    charge = charge + total_cna if cna.fl_charge

    session[:value_cna] = (session[:value_cna].nil? ? 0 : session[:value_cna]) + (amount.nil? ? 0 : amount)
    session[:total_multa] = (session[:total_multa].nil? ? 0 : session[:total_multa]) + (multa.nil? ? 0 : multa)
    session[:total_juros] = (session[:total_juros].nil? ? 0 : session[:total_juros]) + (juros.nil? ? 0 : juros)
    session[:total_cobrado] = (session[:total_cobrado].nil? ? 0 : session[:total_cobrado]) + (charge.nil? ? 0 : charge)
    session[:total_cna] = (session[:total_cna].nil? ? 0 : session[:total_cna]) + (total_cna.nil? ? 0 : total_cna)

    total_cna
  end

end
