class CreateArea < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.references :unit, index: true, foreign_key: true
      t.references :taxpayer, index: true, foreign_key: true
      t.integer :year
      t.string :nr_document
      t.string :name
      t.string :address
      t.string :state
      t.string :city
      t.float :vtnt
      t.float :area
      t.float :modulo
      t.float :degree_of_use
      t.float :usable_area
    end
  end
end
