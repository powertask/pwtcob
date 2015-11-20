class City < ActiveRecord::Base
  belongs_to :unit

  enum status: [:charge, :not_charge]

  validates_presence_of :unit_id, :status
  
end
