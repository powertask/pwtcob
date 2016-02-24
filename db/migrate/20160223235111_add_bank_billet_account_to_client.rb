class AddBankBilletAccountToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :bank_billet_account, index: true, foreign_key: true
  end
end
