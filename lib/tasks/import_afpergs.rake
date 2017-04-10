namespace :db do

  desc "Import data"

  task :import_afpergs => :environment do

    begin

      require 'csv'

      ActiveRecord::Base.transaction do

        puts "========> Import data from CSV"

        csv_file = CSV.read('lib/tasks/afpergs.csv')

        csv_file.each do |row|

          city = City.where('name = ? AND state = ?', row[21].upcase, 'RS').first

          unless city.present?
            city = City.new
            city.name = row[21].upcase
            city.state = 'RS'
            city.unit_id = 1
            city.fl_charge = true
            city.save!
          end

          taxpayer = Taxpayer.where("unit_id = ? AND client_id = ? AND name = ?", 1, 3, row[3]).first

          unless taxpayer.present?

            taxpayer = Taxpayer.new
            taxpayer.unit_id = 1
            taxpayer.client_id = 3
            taxpayer.name = row[3]
            taxpayer.cpf = row[4]
            taxpayer.origin_code = row[1]
            taxpayer.zipcode = row[16]
            taxpayer.address = row[17] + ', ' + row[18]
            taxpayer.complement = row[19]
            taxpayer.neighborhood = row[20]
            taxpayer.city_id = city.id
            taxpayer.state = 'RS'
            taxpayer.save!

            if row[10].present?
              taxpayer_contact = TaxpayerContact.new
              taxpayer_contact.taxpayer_id = taxpayer.id
              taxpayer_contact.name = row[3]
              taxpayer_contact.description = 'Telefone 1'
              taxpayer_contact.phone = row[10]
              taxpayer_contact.save!
            end
            
            if row[11].present?
              taxpayer_contact = TaxpayerContact.new
              taxpayer_contact.taxpayer_id = taxpayer.id
              taxpayer_contact.name = row[3]
              taxpayer_contact.description = 'Telefone 2'
              taxpayer_contact.phone = row[11]
              taxpayer_contact.save!
            end

            if row[12].present?
              taxpayer_contact = TaxpayerContact.new
              taxpayer_contact.taxpayer_id = taxpayer.id
              taxpayer_contact.name = row[3]
              taxpayer_contact.description = 'Telefone 3'
              taxpayer_contact.phone = row[12]
              taxpayer_contact.save!
            end
            
            if row[13].present?
              taxpayer_contact = TaxpayerContact.new
              taxpayer_contact.taxpayer_id = taxpayer.id
              taxpayer_contact.name = row[3]
              taxpayer_contact.description = 'Telefone 4'
              taxpayer_contact.phone = row[13]
              taxpayer_contact.save!
            end
            
            if row[14].present?
              taxpayer_contact = TaxpayerContact.new
              taxpayer_contact.taxpayer_id = taxpayer.id
              taxpayer_contact.name = row[3]
              taxpayer_contact.description = 'Email 1'
              taxpayer_contact.email = row[14]
              taxpayer_contact.save!
            end

            if row[15].present?
              taxpayer_contact = TaxpayerContact.new
              taxpayer_contact.taxpayer_id = taxpayer.id
              taxpayer_contact.name = row[3]
              taxpayer_contact.description = 'Email 2'
              taxpayer_contact.email = row[15]
              taxpayer_contact.save!
            end
          end


          x = row[6].split('/')
          due_at = Date.new(('20'<<x[2]).to_i, x[1].to_i, x[0].to_i)

          cna = Cna.new
          cna.unit_id = 1
          cna.client_id = 3
          cna.taxpayer_id = taxpayer.id
          cna.year = due_at.year
          cna.nr_document = row[5]
          cna.amount = (row[7] + '.' + row[8]).to_f
          cna.stage = :normal
          cna.status = :not_pay
          cna.start_at = due_at
          cna.due_at = due_at
          cna.fl_charge = false
          cna.save!
        end

      end

      rescue ActiveRecord::RecordInvalid => e
        puts e.record.errors.full_messages      

    end
  end
end
