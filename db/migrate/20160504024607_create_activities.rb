class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :task, index: true, foreign_key: true
      t.references :taxpayer, index: true, foreign_key: true
      t.string :description

      t.timestamps null: false

    end
  end
end
