class AddFeeToUnit < ActiveRecord::Migration
  def change
    add_column :units, :unit_fee, :decimal
  end
end
