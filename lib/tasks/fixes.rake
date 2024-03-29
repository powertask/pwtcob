namespace :fixes do

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
    	e = Employee.create!(:name => 'Claudia Silva', :email => 'claudia.silva@gianellimartins.com.br', :phone => '0', :unit_id => 1)
		u = User.create!(:password => 'ClaudiaSilva',  :email => 'claudia.silva@gianellimartins.com.br', :password_confirmation => 'ClaudiaSilva', :unit_id => 1, :profile => 1, :employee_id => e.id)
	end

	desc "allocate employees"
	task :allocate_employess => :environment do
		cnas1 = Cna.find_by_sql('select c.taxpayer_id, count(*), sum(c.amount) from cnas c, taxpayers t where c.taxpayer_id = t.id and t.employee_id is null group by taxpayer_id order by 3 DESC')
		cnas = Cna.find_by_sql('select id from taxpayers where employee_id is null ')
		
		employees = Employee.find_by_sql('select id from employees where id in (34,27,35)')
		row = 0
		total = employees.size 
		
		cnas.each do |c|
			#taxpayer = Taxpayer.where('unit_id = ? and id = ?', 1, c.taxpayer_id)
			taxpayer = Taxpayer.find_by(unit_id: 1, id: c.id)
			if taxpayer.present?
				employee = employees[row]
				if employee.present? 
					taxpayer.employee_id = employee.id
					taxpayer.save!
					row = row + 1
					row = 0 if (row > total - 1)
				end
			end
		end
	end

  desc "create bank billet account"
    task :create_bank_billet_account => :environment do
		BankBilletAccount.create!(:unit_id => 1, :name => 'Santander 101 - CC 013002997-7', :bank_billet_account => 21)
		BankBilletAccount.create!(:unit_id => 1, :name => 'Banco do Brasil 17 - CC 00011672-6', :bank_billet_account => 47)
    end

	desc "update users"
	task :update_users => :environment do
    e = Employee.all
    e.each do |emp|
      u = User.where('employee_id = ?', emp.id).first
      if u.present?
        u.name = emp.name
        u.phone = emp.phone
        u.save!
      end
    end
	end


end
