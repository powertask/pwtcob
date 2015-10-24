class Lawyer < ActiveRecord::Base
  belongs_to :unit

  validates_presence_of :name, :unit_id

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end

end
