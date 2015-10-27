class CreateCna < ActiveRecord::Migration
  def change
    create_table :cnas do |t|
    	t.references :unit
      t.references :taxpayer

      t.integer :year
      t.string :nr_document
      t.float :amount
      t.integer :stage
      t.integer :status
      t.datetime :start_at
      t.datetime :due_at

    	t.timestamps null: false
    end
  end
end
