namespace :populate_db do
	desc "create users"
	task :create_users => :environment do
		User.create!(:password => 'AndresaSilva', :email => 'desabittencourt@hotmail.com', :password_confirmation => 'AndresaSilva', :unit_id => 1, :profile => 1)
		User.create!(:password => 'CamilaFerreira', :email => 'kamilinha87@hotmail.com', :password_confirmation => 'CamilaFerreira', :unit_id => 1, :profile => 1)
		User.create!(:password => 'CamilaRoballo', :email => 'Camila_roballo@hotmail.com', :password_confirmation => 'CamilaRoballo', :unit_id => 1, :profile => 1)	
		User.create!(:password => 'ClaudiaCilene', :email => 'ccmarquessilva@yahoo.com.br', :password_confirmation => 'ClaudiaCilene', :unit_id => 1, :profile => 1)
		User.create!(:password => 'DanieleSoares', :email => 'kariocasoares@gmail.com', :password_confirmation => 'DanieleSoares', :unit_id => 1, :profile => 1)
		User.create!(:password => 'EdsonSantos', :email => 'edsonluz639@hotmail.com', :password_confirmation => 'EdsonSantos', :unit_id => 1, :profile => 1) 
		User.create!(:password => 'ElisangelaMenezes', :email => 'elisangelag466@gmail.com', :password_confirmation => 'ElisangelaMenezes', :unit_id => 1, :profile => 1)
		User.create!(:password => 'FernandaBagatini', :email => 'bagatinif@hotmail.com', :password_confirmation => 'FernandaBagatini', :unit_id => 1, :profile => 1)
		User.create!(:password => 'MariaKazuko', :email => 'mkazukochiba@gmail.com', :password_confirmation => 'MariaKazuko', :unit_id => 1, :profile => 1)
		User.create!(:password => 'MarianaSantos', :email => 'Mary_antunes2013@gmail.com', :password_confirmation => 'MarianaSantos', :unit_id => 1, :profile => 1)
		User.create!(:password => 'PatriciaSantos', :email => 'patinha.nvr@gmail.com', :password_confirmation => 'PatriciaSantos', :unit_id => 1, :profile => 1)
		User.create!(:password => 'SilviaIraci', :email => 'Silvysucesso2015@gmail.com', :password_confirmation => 'SilviaIraci', :unit_id => 1, :profile => 1)
		User.create!(:password => 'SimonePrado', :email => 'monedoprado@hotmail.com', :password_confirmation => 'SimonePrado', :unit_id => 1, :profile => 1)
		User.create!(:password => 'SimoneVeloso', :email => 'simoneanjo33@hotmail.com', :password_confirmation => 'SimoneVeloso', :unit_id => 1, :profile => 1)
		User.create!(:password => 'TaianaMachado', :email => '_castilho@hotmail.com', :password_confirmation => 'TaianaMachado', :unit_id => 1, :profile => 1)
		User.create!(:password => 'AnaSilvia', :email => 'anasilva_gomes@hotmail.com', :password_confirmation => 'AnaSilvia', :unit_id => 1, :profile => 1)
		User.create!(:password => 'BrendaPadilha', :email => 'brendapadilha96@hotmail.com', :password_confirmation => 'BrendaPadilha', :unit_id => 1, :profile => 1)
		User.create!(:password => 'DeniseFranskowiak', :email => 'denise.bisotto@bol.com.br', :password_confirmation => 'DeniseFranskowiak', :unit_id => 1, :profile => 1)
		User.create!(:password => 'JessicaFriedrich', :email => 'jessicafriedrich04@gmail.com', :password_confirmation => 'JessicaFriedrich', :unit_id => 1, :profile => 1)
		User.create!(:password => 'LucindaMoraes', :email => 'lual.oliver@r7.com', :password_confirmation => 'LucindaMoraes', :unit_id => 1, :profile => 1)
		User.create!(:password => 'RosaneAnjos', :email => 'rouse1906@hotmail.com', :password_confirmation => 'RosaneAnjos', :unit_id => 1, :profile => 1)
		User.create!(:password => 'SabrinaAppolinario', :email => 'sabrinadc66@gmail.com', :password_confirmation => 'SabrinaAppolinario', :unit_id => 1, :profile => 1)
		User.create!(:password => 'SilvaneKussler', :email => 'silvaneks@yahoo.com.br', :password_confirmation => 'SilvaneKussler', :unit_id => 1, :profile => 1)	
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

