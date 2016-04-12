class Redistributed < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user
  belongs_to :taxpayer
    
end
