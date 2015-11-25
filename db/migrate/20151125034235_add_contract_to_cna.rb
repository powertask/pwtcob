class AddContractToCna < ActiveRecord::Migration
  def change
  	add_column :cnas, :contract_id, :integer
  end
end
