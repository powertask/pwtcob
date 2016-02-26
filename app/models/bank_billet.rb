class BankBillet < ActiveRecord::Base
  belongs_to :unit
  belongs_to :bank_billet_account

  enum status: [:generating, :opened, :canceled, :paid, :overdue, :blocked, :chargeback]

  def list(unit)
    self.where("unit_id = ?", unit)
  end

end
