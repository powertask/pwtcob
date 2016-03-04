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

    desc "create users faesc"
    task :create_user_faesc => :environment do
#		User.create!(:password => 'AndreiaFaesc', :email => 'andreia@faesc.com.br', :password_confirmation => 'AndreiaFaesc', :unit_id => 1, :profile => 2)
		User.create!(:password => 'TatianeFaesc', :email => 'tatiane@faesc.com.br', :password_confirmation => 'TatianeFaesc', :unit_id => 1, :profile => 2)
	end

	desc "allocate employees"
	task :allocate_employess => :environment do
		cnas = Cna.find_by_sql('select c.taxpayer_id, count(*), sum(c.amount) from cnas c, taxpayers t where c.taxpayer_id = t.id and t.employee_id is null group by taxpayer_id order by 3 DESC')
		
		employees = Employee.find_by_sql('select id from employees where id not in (21,14,27,4,31,18,6,7)')
		row = 0
		total = employees.size 
		
		cnas.each do |c|
			#taxpayer = Taxpayer.where('unit_id = ? and id = ?', 1, c.taxpayer_id)
			taxpayer = Taxpayer.find_by(unit_id: 1, id: c.taxpayer_id)
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

	desc "create cities"
	task :create_cities => :environment do
		City.create!(:name => 'ABDON BATISTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ABDON BATISTA').blank?
		City.create!(:name => 'ABELARDO LUZ', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ABELARDO LUZ').blank?
		City.create!(:name => 'AGROLANDIA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'AGROLANDIA').blank?
		City.create!(:name => 'AGRONOMICA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'AGRONOMICA').blank?
		City.create!(:name => 'AGUA DOCE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'AGUA DOCE').blank?
		City.create!(:name => 'AGUAS DE CHAPECO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'AGUAS DE CHAPECO').blank?
		City.create!(:name => 'AGUAS FRIAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'AGUAS FRIAS').blank?
		City.create!(:name => 'AGUAS MORNAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'AGUAS MORNAS').blank?
		City.create!(:name => 'ALFREDO WAGNER', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ALFREDO WAGNER').blank?
		City.create!(:name => 'ALTO BELA VISTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ALTO BELA VISTA').blank?
		City.create!(:name => 'ANCHIETA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ANCHIETA').blank?
		City.create!(:name => 'ANGELINA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ANGELINA').blank?
		City.create!(:name => 'ANITAPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ANITAPOLIS').blank?
		City.create!(:name => 'ANTONIO CARLOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ANTONIO CARLOS').blank?
		City.create!(:name => 'APIUNA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'APIUNA').blank?
		City.create!(:name => 'ARABUTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ARABUTA').blank?
		City.create!(:name => 'ARAQUARI', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ARAQUARI').blank?
		City.create!(:name => 'ARARANGUA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ARARANGUA').blank?
		City.create!(:name => 'ARMAZEM', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ARMAZEM').blank?
		City.create!(:name => 'ARROIO TRINTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ARROIO TRINTA').blank?
		City.create!(:name => 'ARVOREDO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ARVOREDO').blank?
		City.create!(:name => 'ASCURRA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ASCURRA').blank?
		City.create!(:name => 'ATALANTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ATALANTA').blank?
		City.create!(:name => 'AURORA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'AURORA').blank?
		City.create!(:name => 'BALNEARIO ARROIO DO SILVA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BALNEARIO ARROIO DO SILVA').blank?
		City.create!(:name => 'BALNEARIO BARRA DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BALNEARIO BARRA DO SUL').blank?
		City.create!(:name => 'BALNEARIO CAMBORIU', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BALNEARIO CAMBORIU').blank?
		City.create!(:name => 'BALNEARIO GAIVOTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BALNEARIO GAIVOTA').blank?
		City.create!(:name => 'BALNEARIO PICARRAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BALNEARIO PICARRAS').blank?
		City.create!(:name => 'BANDEIRANTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BANDEIRANTE').blank?
		City.create!(:name => 'BARRA BONITA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BARRA BONITA').blank?
		City.create!(:name => 'BARRA VELHA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BARRA VELHA').blank?
		City.create!(:name => 'BELA VISTA DO TOLDO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BELA VISTA DO TOLDO').blank?
		City.create!(:name => 'BELMONTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BELMONTE').blank?
		City.create!(:name => 'BENEDITO NOVO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BENEDITO NOVO').blank?
		City.create!(:name => 'BIGUACU', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BIGUACU').blank?
		City.create!(:name => 'BLUMENAU', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BLUMENAU').blank?
		City.create!(:name => 'BOM JESUS DO OESTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BOM JESUS DO OESTE').blank?
		City.create!(:name => 'BOM JESUS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BOM JESUS').blank?
		City.create!(:name => 'BOMBINHAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BOMBINHAS').blank?
		City.create!(:name => 'BOTUVERA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BOTUVERA').blank?
		City.create!(:name => 'BRACO DO NORTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BRACO DO NORTE').blank?
		City.create!(:name => 'BRACO DO TROMBUDO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BRACO DO TROMBUDO').blank?
		City.create!(:name => 'BRUNOPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BRUNOPOLIS').blank?
		City.create!(:name => 'BRUSQUE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'BRUSQUE').blank?
		City.create!(:name => 'CACADOR', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CACADOR').blank?
		City.create!(:name => 'CAIBI', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CAIBI').blank?
		City.create!(:name => 'CALMON', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CALMON').blank?
		City.create!(:name => 'CAMBORIU', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CAMBORIU').blank?
		City.create!(:name => 'CAMPO ALEGRE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CAMPO ALEGRE').blank?
		City.create!(:name => 'CAMPO ERE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CAMPO ERE').blank?
		City.create!(:name => 'CAMPOS NOVOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CAMPOS NOVOS').blank?
		City.create!(:name => 'CANELINHA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CANELINHA').blank?
		City.create!(:name => 'CANOINHAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CANOINHAS').blank?
		City.create!(:name => 'CAPINZAL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CAPINZAL').blank?
		City.create!(:name => 'CAPIVARI DE BAIXO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CAPIVARI DE BAIXO').blank?
		City.create!(:name => 'CATANDUVAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CATANDUVAS').blank?
		City.create!(:name => 'CAXAMBU DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CAXAMBU DO SUL').blank?
		City.create!(:name => 'CHAPADAO DO LAGEADO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CHAPADAO DO LAGEADO').blank?
		City.create!(:name => 'CHAPECO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CHAPECO').blank?
		City.create!(:name => 'COCAL DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'COCAL DO SUL').blank?
		City.create!(:name => 'CONCORDIA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CONCORDIA').blank?
		City.create!(:name => 'CORDILHEIRA ALTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CORDILHEIRA ALTA').blank?
		City.create!(:name => 'CORONEL FREITAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CORONEL FREITAS').blank?
		City.create!(:name => 'CORONEL MARTINS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CORONEL MARTINS').blank?
		City.create!(:name => 'CORUPA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CORUPA').blank?
		City.create!(:name => 'CRICIUMA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CRICIUMA').blank?
		City.create!(:name => 'CUNHA PORA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CUNHA PORA').blank?
		City.create!(:name => 'CUNHATAI', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CUNHATAI').blank?
		City.create!(:name => 'CURITIBANOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'CURITIBANOS').blank?
		City.create!(:name => 'DESCANSO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'DESCANSO').blank?
		City.create!(:name => 'DIONISIO CERQUEIRA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'DIONISIO CERQUEIRA').blank?
		City.create!(:name => 'DONA EMMA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'DONA EMMA').blank?
		City.create!(:name => 'DOUTOR PEDRINHO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'DOUTOR PEDRINHO').blank?
		City.create!(:name => 'ENTRE RIOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ENTRE RIOS').blank?
		City.create!(:name => 'ERMO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ERMO').blank?
		City.create!(:name => 'ERVAL VELHO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ERVAL VELHO').blank?
		City.create!(:name => 'FAXINAL DOS GUEDES', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'FAXINAL DOS GUEDES').blank?
		City.create!(:name => 'FLOR DO SERTAO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'FLOR DO SERTAO').blank?
		City.create!(:name => 'FLORIANOPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'FLORIANOPOLIS').blank?
		City.create!(:name => 'FORMOSA DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'FORMOSA DO SUL').blank?
		City.create!(:name => 'FORQUILHINHA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'FORQUILHINHA').blank?
		City.create!(:name => 'FRAIBURGO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'FRAIBURGO').blank?
		City.create!(:name => 'FREI ROGERIO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'FREI ROGERIO').blank?
		City.create!(:name => 'GALVAO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GALVAO').blank?
		City.create!(:name => 'GAROPABA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GAROPABA').blank?
		City.create!(:name => 'GARUVA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GARUVA').blank?
		City.create!(:name => 'GASPAR', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GASPAR').blank?
		City.create!(:name => 'GOVERNADOR CELSO RAMOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GOVERNADOR CELSO RAMOS').blank?
		City.create!(:name => 'GRAO PARA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GRAO PARA').blank?
		City.create!(:name => 'GRAVATAL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GRAVATAL').blank?
		City.create!(:name => 'GUABIRUBA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GUABIRUBA').blank?
		City.create!(:name => 'GUARACIABA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GUARACIABA').blank?
		City.create!(:name => 'GUARAMIRIM', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GUARAMIRIM').blank?
		City.create!(:name => 'GUARUJA DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GUARUJA DO SUL').blank?
		City.create!(:name => 'GUATAMBU', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'GUATAMBU').blank?
		City.create!(:name => 'HERVAL DO OESTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'HERVAL DO OESTE').blank?
		City.create!(:name => 'IBIAM', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IBIAM').blank?
		City.create!(:name => 'IBICARE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IBICARE').blank?
		City.create!(:name => 'IBIRAMA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IBIRAMA').blank?
		City.create!(:name => 'ICARA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ICARA').blank?
		City.create!(:name => 'ILHOTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ILHOTA').blank?
		City.create!(:name => 'IMARUI', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IMARUI').blank?
		City.create!(:name => 'IMBITUBA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IMBITUBA').blank?
		City.create!(:name => 'IMBUIA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IMBUIA').blank?
		City.create!(:name => 'INDAIAL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'INDAIAL').blank?
		City.create!(:name => 'IOMERE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IOMERE').blank?
		City.create!(:name => 'IPIRA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IPIRA').blank?
		City.create!(:name => 'IPORA DO OESTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IPORA DO OESTE').blank?
		City.create!(:name => 'IPUACU', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IPUACU').blank?
		City.create!(:name => 'IPUMIRIM', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IPUMIRIM').blank?
		City.create!(:name => 'IRACEMINHA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IRACEMINHA').blank?
		City.create!(:name => 'IRANI', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IRANI').blank?
		City.create!(:name => 'IRATI', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IRATI').blank?
		City.create!(:name => 'IRINEOPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'IRINEOPOLIS').blank?
		City.create!(:name => 'ITA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ITA').blank?
		City.create!(:name => 'ITAIOPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ITAIOPOLIS').blank?
		City.create!(:name => 'ITAJAI', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ITAJAI').blank?
		City.create!(:name => 'ITAPEMA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ITAPEMA').blank?
		City.create!(:name => 'ITAPIRANGA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ITAPIRANGA').blank?
		City.create!(:name => 'ITAPOA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ITAPOA').blank?
		City.create!(:name => 'ITUPORANGA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ITUPORANGA').blank?
		City.create!(:name => 'JABORA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JABORA').blank?
		City.create!(:name => 'JACINTO MACHADO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JACINTO MACHADO').blank?
		City.create!(:name => 'JAGUARUNA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JAGUARUNA').blank?
		City.create!(:name => 'JARAGUA DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JARAGUA DO SUL').blank?
		City.create!(:name => 'JARDINOPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JARDINOPOLIS').blank?
		City.create!(:name => 'JOACABA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JOACABA').blank?
		City.create!(:name => 'JOINVILLE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JOINVILLE').blank?
		City.create!(:name => 'JOSE BOITEUX', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JOSE BOITEUX').blank?
		City.create!(:name => 'JUPIA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'JUPIA').blank?
		City.create!(:name => 'LACERDOPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LACERDOPOLIS').blank?
		City.create!(:name => 'LAGUNA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LAGUNA').blank?
		City.create!(:name => 'LAJEADO GRANDE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LAJEADO GRANDE').blank?
		City.create!(:name => 'LAURENTINO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LAURENTINO').blank?
		City.create!(:name => 'LAURO MULLER', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LAURO MULLER').blank?
		City.create!(:name => 'LEBON REGIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LEBON REGIS').blank?
		City.create!(:name => 'LEOBERTO LEAL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LEOBERTO LEAL').blank?
		City.create!(:name => 'LINDOIA DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LINDOIA DO SUL').blank?
		City.create!(:name => 'LONTRAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LONTRAS').blank?
		City.create!(:name => 'LUIZ ALVES', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LUIZ ALVES').blank?
		City.create!(:name => 'LUZERNA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'LUZERNA').blank?
		City.create!(:name => 'MACIEIRA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MACIEIRA').blank?
		City.create!(:name => 'MAFRA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MAFRA').blank?
		City.create!(:name => 'MAJOR GERCINO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MAJOR GERCINO').blank?
		City.create!(:name => 'MAJOR VIEIRA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MAJOR VIEIRA').blank?
		City.create!(:name => 'MARACAJA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MARACAJA').blank?
		City.create!(:name => 'MARAVILHA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MARAVILHA').blank?
		City.create!(:name => 'MAREMA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MAREMA').blank?
		City.create!(:name => 'MASSARANDUBA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MASSARANDUBA').blank?
		City.create!(:name => 'MATOS COSTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MATOS COSTA').blank?
		City.create!(:name => 'MELEIRO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MELEIRO').blank?
		City.create!(:name => 'MIRIM DOCE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MIRIM DOCE').blank?
		City.create!(:name => 'MODELO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MODELO').blank?
		City.create!(:name => 'MONDAI', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MONDAI').blank?
		City.create!(:name => 'MONTE CARLO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MONTE CARLO').blank?
		City.create!(:name => 'MONTE CASTELO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MONTE CASTELO').blank?
		City.create!(:name => 'MORRO DA FUMACA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MORRO DA FUMACA').blank?
		City.create!(:name => 'MORRO GRANDE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'MORRO GRANDE').blank?
		City.create!(:name => 'NAVEGANTES', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'NAVEGANTES').blank?
		City.create!(:name => 'NOVA ERECHIM', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'NOVA ERECHIM').blank?
		City.create!(:name => 'NOVA ITABERABA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'NOVA ITABERABA').blank?
		City.create!(:name => 'NOVA TRENTO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'NOVA TRENTO').blank?
		City.create!(:name => 'NOVA VENEZA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'NOVA VENEZA').blank?
		City.create!(:name => 'NOVO HORIZONTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'NOVO HORIZONTE').blank?
		City.create!(:name => 'ORLEANS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ORLEANS').blank?
		City.create!(:name => 'OURO VERDE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'OURO VERDE').blank?
		City.create!(:name => 'OURO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'OURO').blank?
		City.create!(:name => 'PAIAL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PAIAL').blank?
		City.create!(:name => 'PALHOCA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PALHOCA').blank?
		City.create!(:name => 'PALMA SOLA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PALMA SOLA').blank?
		City.create!(:name => 'PALMITOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PALMITOS').blank?
		City.create!(:name => 'PAPANDUVA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PAPANDUVA').blank?
		City.create!(:name => 'PARAISO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PARAISO').blank?
		City.create!(:name => 'PASSO DE TORRES', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PASSO DE TORRES').blank?
		City.create!(:name => 'PASSOS MAIA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PASSOS MAIA').blank?
		City.create!(:name => 'PAULO LOPES', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PAULO LOPES').blank?
		City.create!(:name => 'PEDRAS GRANDES', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PEDRAS GRANDES').blank?
		City.create!(:name => 'PENHA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PENHA').blank?
		City.create!(:name => 'PERITIBA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PERITIBA').blank?
		City.create!(:name => 'PETROLANDIA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PETROLANDIA').blank?
		City.create!(:name => 'PINHALZINHO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PINHALZINHO').blank?
		City.create!(:name => 'PINHEIRO PRETO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PINHEIRO PRETO').blank?
		City.create!(:name => 'PIRATUBA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PIRATUBA').blank?
		City.create!(:name => 'PLANALTO ALEGRE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PLANALTO ALEGRE').blank?
		City.create!(:name => 'POMERODE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'POMERODE').blank?
		City.create!(:name => 'PONTE ALTA DO NORTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PONTE ALTA DO NORTE').blank?
		City.create!(:name => 'PONTE ALTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PONTE ALTA').blank?
		City.create!(:name => 'PONTE SERRADA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PONTE SERRADA').blank?
		City.create!(:name => 'PORTO BELO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PORTO BELO').blank?
		City.create!(:name => 'PORTO UNIAO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PORTO UNIAO').blank?
		City.create!(:name => 'POUSO REDONDO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'POUSO REDONDO').blank?
		City.create!(:name => 'PRAIA GRANDE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PRAIA GRANDE').blank?
		City.create!(:name => 'PRESIDENTE CASTELO BRANCO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PRESIDENTE CASTELO BRANCO').blank?
		City.create!(:name => 'PRESIDENTE GETULIO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PRESIDENTE GETULIO').blank?
		City.create!(:name => 'PRESIDENTE NEREU', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PRESIDENTE NEREU').blank?
		City.create!(:name => 'PRINCESA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'PRINCESA').blank?
		City.create!(:name => 'QUILOMBO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'QUILOMBO').blank?
		City.create!(:name => 'RANCHO QUEIMADO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RANCHO QUEIMADO').blank?
		City.create!(:name => 'RIO DAS ANTAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RIO DAS ANTAS').blank?
		City.create!(:name => 'RIO DO CAMPO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RIO DO CAMPO').blank?
		City.create!(:name => 'RIO DO OESTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RIO DO OESTE').blank?
		City.create!(:name => 'RIO DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RIO DO SUL').blank?
		City.create!(:name => 'RIO DOS CEDROS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RIO DOS CEDROS').blank?
		City.create!(:name => 'RIO FORTUNA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RIO FORTUNA').blank?
		City.create!(:name => 'RIO NEGRINHO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RIO NEGRINHO').blank?
		City.create!(:name => 'RIQUEZA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RIQUEZA').blank?
		City.create!(:name => 'RODEIO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'RODEIO').blank?
		City.create!(:name => 'ROMELANDIA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ROMELANDIA').blank?
		City.create!(:name => 'SALETE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SALETE').blank?
		City.create!(:name => 'SALTINHO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SALTINHO').blank?
		City.create!(:name => 'SALTO VELOSO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SALTO VELOSO').blank?
		City.create!(:name => 'SANGAO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANGAO').blank?
		City.create!(:name => 'SANTA CECILIA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANTA CECILIA').blank?
		City.create!(:name => 'SANTA HELENA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANTA HELENA').blank?
		City.create!(:name => 'SANTA ROSA DE LIMA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANTA ROSA DE LIMA').blank?
		City.create!(:name => 'SANTA ROSA DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANTA ROSA DO SUL').blank?
		City.create!(:name => 'SANTA TEREZINHA DO PROGRESSO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANTA TEREZINHA DO PROGRESSO').blank?
		City.create!(:name => 'SANTA TEREZINHA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANTA TEREZINHA').blank?
		City.create!(:name => 'SANTIAGO DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANTIAGO DO SUL').blank?
		City.create!(:name => 'SANTO AMARO DA IMPERATRIZ', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SANTO AMARO DA IMPERATRIZ').blank?
		City.create!(:name => 'SAO BENTO DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO BENTO DO SUL').blank?
		City.create!(:name => 'SAO BERNARDINO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO BERNARDINO').blank?
		City.create!(:name => 'SAO BONIFACIO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO BONIFACIO').blank?
		City.create!(:name => 'SAO CARLOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO CARLOS').blank?
		City.create!(:name => 'SAO CRISTOVAO DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO CRISTOVAO DO SUL').blank?
		City.create!(:name => 'SAO DOMINGOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO DOMINGOS').blank?
		City.create!(:name => 'SAO FRANCISCO DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO FRANCISCO DO SUL').blank?
		City.create!(:name => 'SAO JOAO BATISTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO JOAO BATISTA').blank?
		City.create!(:name => 'SAO JOAO DO ITAPERIU', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO JOAO DO ITAPERIU').blank?
		City.create!(:name => 'SAO JOAO DO OESTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO JOAO DO OESTE').blank?
		City.create!(:name => 'SAO JOAO DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO JOAO DO SUL').blank?
		City.create!(:name => 'SAO JOSE DO CEDRO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO JOSE DO CEDRO').blank?
		City.create!(:name => 'SAO JOSE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO JOSE').blank?
		City.create!(:name => 'SAO LOURENCO DO OESTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO LOURENCO DO OESTE').blank?
		City.create!(:name => 'SAO LUDGERO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO LUDGERO').blank?
		City.create!(:name => 'SAO MARTINHO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO MARTINHO').blank?
		City.create!(:name => 'SAO MIGUEL DA BOA VISTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO MIGUEL DA BOA VISTA').blank?
		City.create!(:name => 'SAO MIGUEL DO OESTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO MIGUEL DO OESTE').blank?
		City.create!(:name => 'SAO PEDRO DE ALCANTARA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAO PEDRO DE ALCANTARA').blank?
		City.create!(:name => 'SAUDADES', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SAUDADES').blank?
		City.create!(:name => 'SCHROEDER', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SCHROEDER').blank?
		City.create!(:name => 'SEARA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SEARA').blank?
		City.create!(:name => 'SERRA ALTA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SERRA ALTA').blank?
		City.create!(:name => 'SIDEROPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SIDEROPOLIS').blank?
		City.create!(:name => 'SOMBRIO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SOMBRIO').blank?
		City.create!(:name => 'SUL BRASIL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'SUL BRASIL').blank?
		City.create!(:name => 'TAIO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TAIO').blank?
		City.create!(:name => 'TANGARA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TANGARA').blank?
		City.create!(:name => 'TIGRINHOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TIGRINHOS').blank?
		City.create!(:name => 'TIJUCAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TIJUCAS').blank?
		City.create!(:name => 'TIMBE DO SUL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TIMBE DO SUL').blank?
		City.create!(:name => 'TIMBO GRANDE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TIMBO GRANDE').blank?
		City.create!(:name => 'TIMBO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TIMBO').blank?
		City.create!(:name => 'TRES BARRAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TRES BARRAS').blank?
		City.create!(:name => 'TREVISO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TREVISO').blank?
		City.create!(:name => 'TREZE DE MAIO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TREZE DE MAIO').blank?
		City.create!(:name => 'TREZE TILIAS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TREZE TILIAS').blank?
		City.create!(:name => 'TROMBUDO CENTRAL', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TROMBUDO CENTRAL').blank?
		City.create!(:name => 'TUBARAO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TUBARAO').blank?
		City.create!(:name => 'TUNAPOLIS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TUNAPOLIS').blank?
		City.create!(:name => 'TURVO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'TURVO').blank?
		City.create!(:name => 'UNIAO DO OESTE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'UNIAO DO OESTE').blank?
		City.create!(:name => 'URUSSANGA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'URUSSANGA').blank?
		City.create!(:name => 'VARGEAO', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'VARGEAO').blank?
		City.create!(:name => 'VARGEM BONITA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'VARGEM BONITA').blank?
		City.create!(:name => 'VARGEM', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'VARGEM').blank?
		City.create!(:name => 'VIDAL RAMOS', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'VIDAL RAMOS').blank?
		City.create!(:name => 'VIDEIRA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'VIDEIRA').blank?
		City.create!(:name => 'VITOR MEIRELES', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'VITOR MEIRELES').blank?
		City.create!(:name => 'WITMARSUM', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'WITMARSUM').blank?
		City.create!(:name => 'XANXERE', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'XANXERE').blank?
		City.create!(:name => 'XAVANTINA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'XAVANTINA').blank?
		City.create!(:name => 'XAXIM', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'XAXIM').blank?
		City.create!(:name => 'ZORTEA', :state => 'SC', :unit_id => 1, :fl_charge => 0) if City.find_by( name: 'ZORTEA').blank?
	end

  desc "create bank billet account"
    task :create_bank_billet_account => :environment do
		BankBilletAccount.create!(:unit_id => 1, :name => 'Santander 101 - CC 013002997-7', :bank_billet_account => 21)
		BankBilletAccount.create!(:unit_id => 1, :name => 'Banco do Brasil 17 - CC 00011672-6', :bank_billet_account => 47)
    end
end

