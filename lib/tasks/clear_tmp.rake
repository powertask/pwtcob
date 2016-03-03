namespace :clear do
  desc "Clears Rails tmp"
  task :tmp => :environment do
     Dir["tmp/*.zip"].each do |i|
     	puts 'Deleting file ' + i
     	File.delete(i)
     end
     puts 'task completed with sucess!'
  end
end