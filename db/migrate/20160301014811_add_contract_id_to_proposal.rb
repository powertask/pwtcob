class AddContractIdToProposal < ActiveRecord::Migration
  def change
  	add_column :contracts, :proposal_id, :integer
  end
end
