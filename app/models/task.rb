class Task < ActiveRecord::Base

	validates_presence_of :unit_id

  enum type: [ :call ]

end