class Unit < ActiveRecord::Base
  validates_presence_of :name

  usar_como_cnpj :cnpj

  has_many :users
  has_many :clients
  has_many :contracts

	def self.unit_fee(unit, total_cnas)

    if total_cnas == 0
      return 0
    end

    if total_cnas.nil?
      return 0
    end

    unit = Unit.find(unit)

    unless unit.valid?
      return 0
    end

    if unit.unit_fee == 0
      return 0
    end

    if unit.unit_fee.nil?
      return 0
    end

    unit_perc   = unit.unit_fee
    unit_amount = total_cnas * unit_perc / 100
    unit_amount = unit_amount.round(2)	  
	end


end
