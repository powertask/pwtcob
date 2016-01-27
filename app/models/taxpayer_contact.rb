class TaxpayerContact < ActiveRecord::Base
  belongs_to :taxpayer

  def self.list(taxpayer)
    self.where("taxpayer_id = ?", taxpayer)
  end

end
