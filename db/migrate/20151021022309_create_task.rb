class CreateTask < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :task_date
      t.string :description

      t.references :unit
      t.references :employee
      t.references :taxpayer
      t.references :category

      t.timestamps null: false
    end
  end
end
