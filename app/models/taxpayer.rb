class Taxpayer < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with TaxpayerValidator

  belongs_to :client
  belongs_to :unit
  belongs_to :city
  belongs_to :user

  has_many :tasks
  has_many :cnas
    
  validates_presence_of :name, :unit_id, :client_id, :city_id

  usar_como_cpf :cpf
  usar_como_cnpj :cnpj

  def self.list(unit, client)
    self.where("unit_id = ? and client_id = ? and user_id = ?", unit, client, current_user.id).order("name ASC")
  end

  def self.chargeble?(taxpayer)
    taxpayer.city.present? and taxpayer.city.fl_charge ? true : false 
  end
  
end