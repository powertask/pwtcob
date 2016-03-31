class AddFlTaxpayerToUser < ActiveRecord::Migration
  def change
  	add_column :users, :fl_taxpayer, :boolean
  end
end
