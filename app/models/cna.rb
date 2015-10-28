class Cna < ActiveRecord::Base
  belongs_to :unit
  
  enum status: [:not_pay, :pay]
  enum stage: [:regular, :law]

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
  
end