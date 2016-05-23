class History < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user
  belongs_to :taxpayer
  belongs_to :word
  belongs_to :client


  def self.list(unit, client)
    self.where("unit_id = ? and client_id = ?", unit, client)
  end
  
end