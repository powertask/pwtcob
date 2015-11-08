class Cna < ActiveRecord::Base
  belongs_to :unit
  belongs_to :taxpayer
  
  enum status: [:not_pay, :pay]
  enum stage: [:regular, :law]

#  usar_como_dinheiro :amount

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
  
end