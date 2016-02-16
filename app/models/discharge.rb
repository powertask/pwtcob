class Discharge < ActiveRecord::Base

  enum status: [:Unprocessed, :Processed]

end
