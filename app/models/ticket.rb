class Ticket < ActiveRecord::Base
  belongs_to :unit

  validates_presence_of :unit_id

  enum ticket_type: [:client, :unit]

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
end
