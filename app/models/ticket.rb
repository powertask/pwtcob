class Ticket < ActiveRecord::Base
  belongs_to :unit
  belongs_to :bank_billet

  validates_presence_of :unit_id

  enum ticket_type: [:client, :unit]

  def self.list(unit)
    self.where("unit_id = ?", unit)
  end
end
