class CreateBankBilletAccounts < ActiveRecord::Migration
  def change
    create_table :bank_billet_accounts do |t|
      t.references :unit, index: true, foreign_key: true
      t.string :name
      t.integer :bank_billet_account

      t.timestamps null: false
    end
  end
end
