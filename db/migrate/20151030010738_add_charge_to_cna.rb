class AddChargeToCna < ActiveRecord::Migration
  def change
	add_column :cnas, :fl_charge, :boolean
  end
end
