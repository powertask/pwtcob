class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.references :unit, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
     end
  end
end
