class AddClientToProposal < ActiveRecord::Migration
  def change
  	add_reference :proposals, :client, index: true, foreign_key: true
  end
end
