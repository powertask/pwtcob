class BankBillet < ActiveRecord::Base
  belongs_to :unit
  belongs_to :bank_billet_account

  has_many :tickets
  
  enum status: [:generating, :opened, :canceled, :paid, :overdue, :blocked, :chargeback, :generation_failed]

  def list(unit)
    self.where("unit_id = ?", unit)
  end

end
