class Index < ActiveRecord::Base
  belongs_to :unit

  validates_presence_of :unit_id, :month, :year

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
end
