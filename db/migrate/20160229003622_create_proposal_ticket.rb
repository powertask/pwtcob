class CreateProposalTicket < ActiveRecord::Migration
  def change
    create_table :proposal_tickets do |t|
        t.references :unit
        t.references :proposal
    	t.integer :ticket_type
    	t.float :amount
    	t.integer :ticket_number
    	t.date :due_at

    	t.timestamps null: false
    end
  end
end
