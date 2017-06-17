class Contract < ActiveRecord::Base
  belongs_to :unit
  belongs_to :taxpayer
  belongs_to :proposal
  belongs_to :user
  belongs_to :contract
  belongs_to :client
  
  has_many :tickets
  has_many :cnas
  
  validates_presence_of :unit_id, :taxpayer_id, :client_id

	enum status: [:active, :cancel, :paid]

  def self.list(unit, client)
    self.where("unit_id = ? AND client_id = ?", unit, client)
  end
  
  def self.list_not_cancel(unit, client)
    self.where("unit_id = ? AND client_id = ? AND status in (0,2)", unit, client)
  end
  
end
