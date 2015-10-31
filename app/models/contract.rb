class Contract < ActiveRecord::Base
  belongs_to :unit
  belongs_to :taxpayer
  belongs_to :employee
  
  has_many :tickets
  
  validates_presence_of :unit_id, :taxpayer_id, :employee_id

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
  
end
