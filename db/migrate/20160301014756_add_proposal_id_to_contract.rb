class AddProposalIdToContract < ActiveRecord::Migration
  def change
  	add_column :proposals, :contract_id, :integer
  end
end
