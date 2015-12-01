class AddDateToInpc < ActiveRecord::Migration
  def change
  	add_column :inpcs, :idx_date, :date
  end
end
