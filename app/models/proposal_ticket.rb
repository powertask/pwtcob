class ProposalTicket < ActiveRecord::Base
  belongs_to :proposal

  enum ticket_type: [:client, :unit]
  
  def self.list(proposal)
    self.where("proposal_id = ?", proposal)
  end

end
