class AddContractOriginCode < ActiveRecord::Migration
  def change
  	add_column :contracts, :origin_code, :integer
  end
end
