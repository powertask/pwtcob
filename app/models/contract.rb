class Contract < ActiveRecord::Base
  belongs_to :unit
  belongs_to :taxpayer
  belongs_to :proposal
  belongs_to :user
  
  has_many :tickets
  has_many :cnas
  
  validates_presence_of :unit_id, :taxpayer_id

	enum status: [:active, :cancel, :paid]

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
  
end
