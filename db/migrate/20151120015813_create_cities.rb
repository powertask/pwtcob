class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :status
      t.string :state
      t.references :unit

      t.timestamps null: false
    end
  end
end
