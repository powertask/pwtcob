namespace :populate_db do
  desc "create users"
    task :create_users => :environment do
		User.create!(:password => 'CamilaSilva', :email => 'camila.silva@gianellimartins.com.br', :password_confirmation => 'CamilaSilva', :unit_id => 1, :profile => 1, :employee_id => 3)
		User.create!(:password => 'DanieleSoares', :email => 'daniele.soares@gianellimartins.com.br', :password_confirmation => 'DanieleSoares', :unit_id => 1, :profile => 1, :employee_id => 6)
		User.create!(:password => 'DaisyAguiar', :email => 'daisy.aguiar@gianellimartins.com.br', :password_confirmation => 'DaisyAguiar', :unit_id => 1, :profile => 1, :employee_id => 27)
		User.create!(:password => 'EdsonLuz', :email => 'edson.luz@gianellimartins.com.br', :password_confirmation => 'EdsonLuz', :unit_id => 1, :profile => 1, :employee_id => 7)
		User.create!(:password => 'FernandaBagatini', :email => 'fernanda.bagatini@gianellimartins.com.br', :password_confirmation => 'FernandaBagatini', :unit_id => 1, :profile => 1, :employee_id => 9)
		User.create!(:password => 'JessicaSilveira', :email => 'jessica.silveira@gianellimartins.com.br', :password_confirmation => 'JessicaSilveira', :unit_id => 1, :profile => 1, :employee_id => 22)
		User.create!(:password => 'JulianaRocha', :email => 'juliana.rocha@gianellimartins.com.br', :password_confirmation => 'JulianaRocha', :unit_id => 1, :profile => 1, :employee_id => 28)
		User.create!(:password => 'MariaKazuko', :email => 'kazuko@gianellimartins.com.br', :password_confirmation => 'MariaKazuko', :unit_id => 1, :profile => 1, :employee_id => 10)
		User.create!(:password => 'PatriciaGusmao', :email => 'patriciagusmao@gianellimartins.com.br', :password_confirmation => 'PatriciaGusmao', :unit_id => 1, :profile => 1, :employee_id => 29)
		User.create!(:password => 'SilviaIraci', :email => 'silvia.santos@gianellimartins.com.br', :password_confirmation => 'SilviaIraci', :unit_id => 1, :profile => 1, :employee_id => 30)
		User.create!(:password => 'SimonePrado', :email => 'simonepereira@gianellimartins.com.br', :password_confirmation => 'SimonePrado', :unit_id => 1, :profile => 1, :employee_id => 14)
		User.create!(:password => 'SimoneVeloso', :email => 'simoneveloso@gianellimartins.com.br', :password_confirmation => 'SimoneVeloso', :unit_id => 1, :profile => 1, :employee_id => 15)
		User.create!(:password => 'SusanaLima', :email => 'susana@gianellimartins.com.br', :password_confirmation => 'SusanaLima', :unit_id => 1, :profile => 1, :employee_id => 16)
		User.create!(:password => 'TaianaCastilho', :email => 'taiana.castilho@gianellimartins.com.br', :password_confirmation => 'TaianaCastilho', :unit_id => 1, :profile => 1, :employee_id => 17)
		User.create!(:password => 'AnaSilvia', :email => 'ana.gomes@gianellimartins.com.br', :password_confirmation => 'AnaSilvia', :unit_id => 1, :profile => 1, :employee_id => 18)
		User.create!(:password => 'BrunaPires', :email => 'brunapires@gianellimartins.com.br', :password_confirmation => 'BrunaPires', :unit_id => 1, :profile => 1, :employee_id => 20)
		User.create!(:password => 'CamilaMolina', :email => 'camila.molina@gianellimartins.com.br', :password_confirmation => 'CamilaMolina', :unit_id => 1, :profile => 1, :employee_id => 4)
		User.create!(:password => 'DeniseBisotto', :email => 'denise.bisotto@gianellimartins.com.br', :password_confirmation => 'DeniseBisotto', :unit_id => 1, :profile => 1, :employee_id => 21)
		User.create!(:password => 'IsabelCarboni', :email => 'isabel.carboni@gianellimartins.com.br', :password_confirmation => 'IsabelCarboni', :unit_id => 1, :profile => 1, :employee_id => 31)
		User.create!(:password => 'LucindaOliveira', :email => 'lucinda.oliveira@gianellimartins.com.br', :password_confirmation => 'LucindaOliveira', :unit_id => 1, :profile => 1, :employee_id => 23)
		User.create!(:password => 'RosaneAnjos', :email => 'rosane.anjos@gianellimartins.com.br', :password_confirmation => 'RosaneAnjos', :unit_id => 1, :profile => 1, :employee_id => 24)
		User.create!(:password => 'SabrinaCruz', :email => 'sabrinacruz@gianellimartins.com.br', :password_confirmation => 'SabrinaCruz', :unit_id => 1, :profile => 1, :employee_id => 25)
		User.create!(:password => 'AlanaPereira', :email => 'alana.pereira@gianellimartins.com.br', :password_confirmation => 'AlanaPereira', :unit_id => 1, :profile => 1, :employee_id => 32)
		User.create!(:password => 'SilvaneSchneider', :email => 'silvane.schneider@gianellimartins.com.br', :password_confirmation => 'SilvaneSchneider', :unit_id => 1, :profile => 1, :employee_id => 26)
    end

	desc "allocate employees"
	task :allocate_employess => :environment do
		cnas = Cna.find_by_sql('select taxpayer_id, count(*), sum(amount) from cnas group by taxpayer_id order by 3 DESC')
		count_employees = Employee.count
		count_limit = 1
		cnas.each do |c|
			#taxpayer = Taxpayer.where('unit_id = ? and id = ?', 1, c.taxpayer_id)
			taxpayer = Taxpayer.find_by(unit_id: 1, id: c.taxpayer_id)
			if taxpayer.present?
				employee = Employee.find(count_limit)
				if employee.present?
					taxpayer.employee_id = employee.id
					taxpayer.save!
					count_limit = count_limit + 1
					count_limit = 1 if (count_limit > count_employees)
				end
			end
		end
	end
end

