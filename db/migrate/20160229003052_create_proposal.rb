class CreateProposal < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.references :unit
      t.references :user
      t.references :taxpayer
      t.references :employee
      t.float :unit_amount
      t.float :unit_fee
      t.integer :unit_ticket_quantity
      t.integer :client_ticket_quantity
      t.float :client_amount
      t.date :unit_due_at
      t.date :client_due_at
      t.integer :status

      t.timestamps null: false
    end
  end
end
