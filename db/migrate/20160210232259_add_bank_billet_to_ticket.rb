class AddBankBilletToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :bank_billet_id, :integer
  end
end
