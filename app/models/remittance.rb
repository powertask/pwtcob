class Remittance < ActiveRecord::Base

  enum status: [:Unprocessed, :Processed, :Downloaded, :Sent]

end
