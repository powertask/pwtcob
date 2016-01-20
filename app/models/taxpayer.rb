class Taxpayer < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with TaxpayerValidator

  belongs_to :client
  belongs_to :unit
  belongs_to :city
  belongs_to :employee

  has_many :tasks
  has_many :cnas
    
  validates_presence_of :name, :unit_id, :client_id, :city_id

  usar_como_cpf :cpf
  usar_como_cnpj :cnpj

  def self.list(unit)
    self.where("unit_id = ? and employee_id = ?", unit, session[:employee_id]).order("name ASC")
  end
  
end