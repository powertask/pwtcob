class CreateTicket < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
    	t.references :unit
    	t.references :contract

      t.integer :ticket_type
      t.float :amount
      t.integer :ticket_number
      t.datetime :due

      t.timestamps null: false

    end
  end
end
