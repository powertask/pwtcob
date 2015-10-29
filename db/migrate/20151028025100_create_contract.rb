class CreateContract < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.references :unit
      t.references :taxpayer
      t.references :employee

      t.float :unit_amount
      t.decimal :unit_fee
      t.integer :unit_ticket_quantity
      t.float :client_amount
      t.integer :client_ticket_quantity

      t.datetime :contract_date

      t.timestamps null: false

    end
  end
end
