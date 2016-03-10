class City < ActiveRecord::Base
  belongs_to :unit

  has_many :taxpayers

  validates_presence_of :unit_id, :name, :state

	scope :chargeble, -> { where(fl_charge: true) }

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
end
