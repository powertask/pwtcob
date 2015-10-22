class CreateCategory < ActiveRecord::Migration
  def change
    create_table :categories do |t|
    	t.string :name
    	t.references :unit

      	t.timestamps null: false
    end
  end
end
