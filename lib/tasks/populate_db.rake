namespace :populate_db do

	desc "update CNAS"
	task :cnas_20160420 => :environment do
    xls = Roo::Spreadsheet.open('cnas.xls', extension: :xlsx)

    row_number = 0

    xls.sheet(0).each_row_streaming do |row|

      row_number = row_number + 1

      if row_number > 1

        name = xls.sheet(0).cell(row_number, 1)
        year = xls.sheet(0).cell(row_number, 10)
        amount = xls.sheet(0).cell(row_number, 13).real.to_f

        taxpayer = Taxpayer.where( 'name = ?', name).first

        if taxpayer.present?
          cna = Cna.where('taxpayer_id = ? AND year = ?', taxpayer.id, year)

          if cna.empty?
            c = Cna.new
            c.unit_id = 1
            c.taxpayer_id = taxpayer.id
            c.year = year
            c.amount = amount
            c.stage = 1
            c.status = 0
            c.fl_charge = false
            c.save!
          end
        end
      end
    end
	end


	desc "create users Claudia Silva"
    task :create_user_claudia_silva => :environment do
		u = User.create!(:password => 'ClaudiaSilva',  :email => 'claudia.silva@gianellimartins.com.br', :password_confirmation => 'ClaudiaSilva', :unit_id => 1, :profile => 1)
	end



	desc "set list to users"
	task :set_list_to_users => :environment do


    ## Lista de usuários do sistema
    # => select id, name, email, unit_id, deleted_at, fl_taxpayer from users order by 2;

    ## Lista de taxpayers para um usuário
    # => select count(1) from taxpayers where user_id = 97;


    ## Lista sem colaborador definido FAESC
    lists = Cna.find_by_sql(' select c.taxpayer_id, count(*), sum(c.amount) from cnas c, taxpayers t where c.taxpayer_id = t.id and t.user_id is null and t.client_id = 1 group by taxpayer_id order by 3 DESC')


		## Escolher colaboradores para distribuir a lista
    users = User.find_by_sql('select id from users where id in (79,99)')

		row = 0
		total = users.size 
		
		begin
      ActiveRecord::Base.transaction do
        lists.each do |list|
          taxpayer = Taxpayer.find_by(unit_id: 1, id: list.taxpayer_id)
  
          if taxpayer.present?
            user = users[row]
            
            if user.present? 
              taxpayer.user_id = user.id
              taxpayer.save!
              row = row + 1
              row = 0 if (row > total - 1)
            end
          end
        end
      end

      rescue ActiveRecord::RecordInvalid => e
        puts e.record.errors.full_messages
    end
	end



  desc "create bank billet account"
    task :create_bank_billet_account => :environment do
		BankBilletAccount.create!(:unit_id => 1, :name => 'Santander 101 - CC 013002997-7', :bank_billet_account => 21)
		BankBilletAccount.create!(:unit_id => 1, :name => 'Banco do Brasil 17 - CC 00011672-6', :bank_billet_account => 47)
    end


end
