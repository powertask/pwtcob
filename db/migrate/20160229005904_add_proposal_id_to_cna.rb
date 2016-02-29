class AddProposalIdToCna < ActiveRecord::Migration
  def change
  	add_column :cnas, :proposal_id, :integer
  end
end
