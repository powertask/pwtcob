class AddStatusToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :status, :integer
  end
end
