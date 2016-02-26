class CreateBankBillet < ActiveRecord::Migration
  def change
    create_table :bank_billets do |t|
      t.references :unit, index: true, foreign_key: true
      t.references :bank_billet_account, index: true, foreign_key: true
      t.integer :origin_code
      t.string :our_number
      t.float :amount
      t.date :expire_at
      t.string :customer_person_name
      t.string :customer_cnpj_cpf
      t.integer :status
      t.date :paid_at
      t.float :paid_amount
      t.string :shorten_url
      t.float :fine_for_delay
      t.float :late_payment_interest
      t.date :document_date
      t.float :document_amount
      t.timestamps null: false
    end
  end
end
