class History < ActiveRecord::Base
  belongs_to :unit
  belongs_to :employee
  belongs_to :taxpayer


  def self.list(unit)
    self.where("unit_id = ?", unit).order('description ASC')
  end
  
end