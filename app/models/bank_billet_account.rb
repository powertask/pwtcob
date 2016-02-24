class BankBilletAccount < ActiveRecord::Base
	belongs_to :unit

	def self.list(unit)
		self.where("unit_id = ?", unit).order("name ASC")
	end

end
