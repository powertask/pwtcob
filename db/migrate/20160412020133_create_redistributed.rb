class CreateRedistributed < ActiveRecord::Migration
  def change
    create_table :redistributeds do |t|
    	t.references :taxpayer
    	t.integer :user_prev_id
      t.references :user
      t.references :unit
    	t.datetime :distributed_at

    	t.timestamps null: false
    end
  end
end
