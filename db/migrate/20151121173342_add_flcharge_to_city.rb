class AddFlchargeToCity < ActiveRecord::Migration
  def change
  	add_column :cities, :fl_charge, :boolean
  end
end
