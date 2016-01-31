class Unit < ActiveRecord::Base
  validates_presence_of :name

  usar_como_cnpj :cnpj

  has_many :users
  has_many :clients
  has_many :contracts


	def self.unit_fee(unit, total_cnas)

	    unit = Unit.find(unit)

	    unit_perc =  unit.unit_fee
	    unit_perc = 0 if unit_perc.nil?

	    unit_amount = total_cnas * unit_perc / 100
	    unit_amount = unit_amount.round(2)
	  
	end


end
