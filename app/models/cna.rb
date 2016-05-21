class Cna < ActiveRecord::Base
  belongs_to :unit
  belongs_to :taxpayer
  belongs_to :contract
  belongs_to :client
  
  enum status: [:not_pay, :pay, :contract, :proposal]
  enum stage: [:lawyer, :normal]

#  usar_como_dinheiro :amount

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
  
end