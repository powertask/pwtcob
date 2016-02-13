class BankBillet < ActiveRecord::Base

  enum status: [:generating, :opened, :canceled, :paid, :overdue, :blocked, :chargeback]

end
