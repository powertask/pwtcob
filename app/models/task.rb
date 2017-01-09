class Task < ActiveRecord::Base

	belongs_to :category
	belongs_to :taxpayer

	validates_presence_of :unit_id

  enum type: [ :call ]

end