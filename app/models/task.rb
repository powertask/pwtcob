class Task < ActiveRecord::Base
  belongs_to :unit
  belongs_to :employee
  belongs_to :taxpayer
  belongs_to :category
  
  validates_presence_of :unit_id, :category_id, :employee_id, :taxpayer_id, :task_date

  def self.list(unit)
    self.where("unit_id = ?", unit).order("name ASC")
  end
  
end
