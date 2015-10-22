class CreateHistory < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :description
      t.datetime :history_date

      t.references :unit
      t.references :category
      t.references :taxpayer
      t.references :employee
      t.references :task

      t.timestamps null: false
    end
  end
end
