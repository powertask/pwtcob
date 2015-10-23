class Employee < ActiveRecord::Base
  belongs_to :unit
  
  validates_presence_of :name, :unit_id
  validates_format_of :phone, :with => /\A^[\d]+$\Z/, :message => " - Deve ser um número"


  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
  
end
