namespace :populate_db do
  desc "create users"
    task :create_users => :environment do
      User.create!(:password => 'DeniseBisotto', :email => 'denise.bisotto@gianellimartins.com.br', :password_confirmation => 'DeniseBisotto', :unit_id => 1, :profile => 1, :employee_id => 21)
      User.create!(:password => 'EdsonSantos', :email => 'edson.luz@gianellimartins.com.br', :password_confirmation => 'EdsonSantos', :unit_id => 1, :profile => 1, :employee_id => 7) 
      User.create!(:password => 'FernandaBagatini', :email => 'fernanda.bagatini@gianellimartins.com.br', :password_confirmation => 'FernandaBagatini', :unit_id => 1, :profile => 1, :employee_id => 9)
      User.create!(:password => 'JessicaSilveira', :email => 'jessica.silveira@gianellimartins.com.br', :password_confirmation => 'JessicaSilveira', :unit_id => 1, :profile => 1, :employee_id => 22)
      User.create!(:password => 'MariaKazuko', :email => 'kazuko@gianellimartins.com.br', :password_confirmation => 'MariaKazuko', :unit_id => 1, :profile => 1, :employee_id => 10)
      User.create!(:password => 'PatriciaSantos', :email => 'patriciagusmao@gianellimartins.com.br', :password_confirmation => 'PatriciaSantos', :unit_id => 1, :profile => 1, :employee_id => 12)
      User.create!(:password => 'SilviaIraci', :email => 'silvia.santos@gianellimartins.com.br', :password_confirmation => 'SilviaIraci', :unit_id => 1, :profile => 1, :employee_id => 13)
      User.create!(:password => 'SimonePereira', :email => 'simonepereira@gianellimartins.com.br', :password_confirmation => 'SimonePereira', :unit_id => 1, :profile => 1, :employee_id => 14)
      User.create!(:password => 'SimoneVeloso', :email => 'simoneveloso@gianellimartins.com.br', :password_confirmation => 'SimoneVeloso', :unit_id => 1, :profile => 1, :employee_id => 15)
      User.create!(:password => 'TaianaMachado', :email => 'taiana.castilho@gianellimartins.com.br ', :password_confirmation => 'TaianaMachado', :unit_id => 1, :profile => 1, :employee_id => 17)
      User.create!(:password => 'AnaSilvia', :email => 'ana.gomes@gianellimartins.com.br', :password_confirmation => 'AnaSilvia', :unit_id => 1, :profile => 1, :employee_id => 18)
      User.create!(:password => 'BrunaPires', :email => 'brunapires@gianellimartins.com.br', :password_confirmation => 'BrunaPires', :unit_id => 1, :profile => 1, :employee_id => 20)
      User.create!(:password => 'LucindaOliveira', :email => 'lucinda.oliveira@gianellimartins.com.br', :password_confirmation => 'LucindaOliveira', :unit_id => 1, :profile => 1, :employee_id => 23)
      User.create!(:password => 'CamilaMolina', :email => 'camila.molina@gianellimartins.com.br', :password_confirmation => 'CamilaMolina', :unit_id => 1, :profile => 1, :employee_id => 4)	
      User.create!(:password => 'RosaneAnjos', :email => 'rosane.anjos@gianellimartins.com.br', :password_confirmation => 'RosaneAnjos', :unit_id => 1, :profile => 1, :employee_id => 24)
      User.create!(:password => 'SabrinaCruz', :email => 'sabrinacruz@gianellimartins.com.br', :password_confirmation => 'SabrinaCruz', :unit_id => 1, :profile => 1, :employee_id => 25)
      User.create!(:password => 'SilvaneSchneider', :email => 'silvane.schneider@gianellimartins.com.br ', :password_confirmation => 'SilvaneSchneider', :unit_id => 1, :profile => 1, :employee_id => 26)	
    end

	desc "update employee to users"
	task :update_employee_to_users => :environment do
		employees = Employee.where('unit_id = ? and email is not null', 1)
		employees.each do |e|
			user = User.find_by(unit_id: 1, email: e.email)
			if user.present? 
				user.employee_id = e.id
				user.save!
			end
		end
	end

	desc "allocate employees"
	task :allocate_employess => :environment do
		cnas = Cna.find_by_sql('select taxpayer_id, count(*), sum(amount) from cnas group by taxpayer_id order by 3 DESC')
		count_employees = Employee.count
		count_limit = 2
		cnas.each do |c|
			#taxpayer = Taxpayer.where('unit_id = ? and id = ?', 1, c.taxpayer_id)
			taxpayer = Taxpayer.find_by(unit_id: 1, id: c.taxpayer_id)
			if taxpayer.present?
				employee = Employee.find(count_limit)
				if employee.present?
					taxpayer.employee_id = employee.id
					taxpayer.save!
					count_limit = count_limit + 1
					count_limit = 2 if (count_limit > count_employees)
				end
			end
		end
	end
end

