class Area < ApplicationRecord
  belongs_to :unit
  

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
  
end
