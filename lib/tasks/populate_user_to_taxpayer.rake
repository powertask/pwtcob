namespace :populate_user_to_taxpayer do

    desc "Populate"
    task :redistribuited => :environment do

    	users = User.user.where('fl_taxpayer = ?', true)



    	e = Employee.create!(:name => 'Claudia Silva', :email => 'claudia.silva@gianellimartins.com.br', :phone => '0', :unit_id => 1)
		u = User.create!(:password => 'ClaudiaSilva',  :email => 'claudia.silva@gianellimartins.com.br', :password_confirmation => 'ClaudiaSilva', :unit_id => 1, :profile => 1, :employee_id => e.id)
	end

end

