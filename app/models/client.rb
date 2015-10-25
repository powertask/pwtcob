class Client < ActiveRecord::Base
  belongs_to :unit
  
  validates_presence_of :name, :unit_id

  usar_como_cnpj :cnpj

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
  
end