class History < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user
  belongs_to :taxpayer


  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
  
end