class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.decimal :fee, precision: 5, scale: 2
    end
  end
end
