class AddInitialEmployees < ActiveRecord::Migration
  def change
	Employee.create(:unit_id => 1, :name => 'Andresa da Silva Bittencourt', :phone => '5185100719', :email => 'desabittencourt@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Camila Ferreira da Silva', :phone => '5184819946', :email => 'kamilinha87@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Camila Roballo Molina', :phone => '5183062303', :email => 'Camila_roballo@hotmail.com')	
	Employee.create(:unit_id => 1, :name => 'Claudia Cilene Marques da silva', :phone => '5193655278', :email => 'ccmarquessilva@yahoo.com.br')
	Employee.create(:unit_id => 1, :name => 'Daniele Soares Alves', :phone => '5184834020', :email => 'kariocasoares@gmail.com')
	Employee.create(:unit_id => 1, :name => 'Edson Santos da Luz', :phone => '5196029141', :email => 'edsonluz639@hotmail.com') 
	Employee.create(:unit_id => 1, :name => 'Elisangela Menezes Godoy', :phone => '5184639601', :email => 'elisangelag466@gmail.com')
	Employee.create(:unit_id => 1, :name => 'Fernanda Bagatini', :phone => '5191474530', :email => 'bagatinif@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Maria Kazuko Chiba de Oliveira', :phone => '5193809101', :email => 'mkazukochiba@gmail.com')
	Employee.create(:unit_id => 1, :name => 'Mariana dos Santos Antunes', :phone => '5192430617', :email => 'Mary_antunes2013@gmail.com')
	Employee.create(:unit_id => 1, :name => 'Patrícia dos santosGusmão', :phone => '5198376945', :email => 'patinha.nvr@gmail.com')
	Employee.create(:unit_id => 1, :name => 'Sílvia Iraci de Oliveira Martins dos Santos', :phone => '5185489746', :email => 'Silvysucesso2015@gmail.com')
	Employee.create(:unit_id => 1, :name => 'Simone Prado Pereira', :phone => '5192119706', :email => 'monedoprado@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Simone Veloso', :phone => '5192545611', :email => 'simoneanjo33@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Susana Martins Lima', :phone => '5192595857')	 
	Employee.create(:unit_id => 1, :name => 'Taiana Machado Castilho', :phone => '5185606460', :email => '_castilho@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Ana Sílvia Gomes dos Santos', :phone => '5184520304', :email => 'anasilva_gomes@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Brenda Padilha Baum', :phone => '5198201065', :email => 'brendapadilha96@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Bruna Pires Furtado', :phone => '5184488672')	 
	Employee.create(:unit_id => 1, :name => 'Denise Franskowiak Bisotto', :phone => '5191497620', :email => 'denise.bisotto@bol.com.br')
	Employee.create(:unit_id => 1, :name => 'Jessica Friedrich Da Silveira', :phone => '5195798052', :email => 'jessicafriedrich04@gmail.com')
	Employee.create(:unit_id => 1, :name => 'Lucinda Moraes Oliveira', :phone => '5191085808', :email => 'lual.oliver@r7.com')
	Employee.create(:unit_id => 1, :name => 'Rosane dos Anjos', :phone => '5192852513', :email => 'rouse1906@hotmail.com')
	Employee.create(:unit_id => 1, :name => 'Sabrina Appolinario da Cruz', :phone => '5189129565', :email => 'sabrinadc66@gmail.com')
	Employee.create(:unit_id => 1, :name => 'Silvane Kussler Schneider', :phone => '5196597880', :email => 'silvaneks@yahoo.com.br')
  end

  def down
  	Employee.delete_all
  end
end
