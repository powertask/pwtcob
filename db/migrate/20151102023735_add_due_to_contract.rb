class AddDueToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :unit_due, :date
    add_column :contracts, :client_due, :date
  end
end
