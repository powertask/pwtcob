class Word < ActiveRecord::Base
  belongs_to :unit

  has_many :histories

  validates_presence_of :unit_id, :name

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
end
