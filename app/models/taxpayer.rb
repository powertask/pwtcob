class Taxpayer < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with TaxpayerValidator

  belongs_to :client
  belongs_to :unit

  has_many :tasks
  has_many :cnas
    
  validates_presence_of :name, :unit_id, :client_id

  usar_como_cpf :cpf
  usar_como_cnpj :cnpj

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
  
end