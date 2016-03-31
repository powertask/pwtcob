class AddUserToTaxpayer < ActiveRecord::Migration
  def change
  	add_reference :taxpayers, :user, index: true, foreign_key: true
  end
end
