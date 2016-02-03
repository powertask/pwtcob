class Home < ActiveRecord::Base

  def self.calc_meses_atraso(_year)
  	date_base = Date.new(_year, 5, 22)
  	date_today = Date.today()
  	(date_today.year * 12 + date_today.month) - (date_base.year * 12 + date_base.month)
  end
end
