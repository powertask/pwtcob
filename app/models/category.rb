class Category < ActiveRecord::Base
  belongs_to :unit
  
  has_many :tasks
  
  validates_presence_of :name, :unit_id

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
  
end
