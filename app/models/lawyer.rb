class Lawyer < ActiveRecord::Base
	include ActiveModel::Validations
	validates_with LawyerValidator

	belongs_to :unit

	validates_presence_of :name, :unit_id, :lawyer_code

	usar_como_cpf :cpf
	usar_como_cnpj :cnpj

	def self.list(unit)
		self.where("unit_id = ?", unit).order("name ASC")
	end

end
