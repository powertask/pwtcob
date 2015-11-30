class CreateInpc < ActiveRecord::Migration
  def change
    create_table :inpcs do |t|
      t.references :unit, index: true, foreign_key: true
      t.integer :month
      t.integer :year
      t.decimal :idx, precision: 10, scale: 4

      t.timestamps null: false    	
    end
  end
end
