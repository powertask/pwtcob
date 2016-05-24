class Proposal < ActiveRecord::Base
  belongs_to :unit
  belongs_to :taxpayer
  belongs_to :user
  belongs_to :contract
  belongs_to :client
  
  has_many :tickets
  has_many :cnas
  
  validates_presence_of :unit_id, :taxpayer_id, :client_id

	enum status: [:active, :cancel, :contract]

  def self.list(unit, client)
    self.where("unit_id = ? and client_id = ?", unit, client)
  end
  
end
