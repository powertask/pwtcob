class AddPhoneToTaxpayer < ActiveRecord::Migration
  def change
  	 add_column :taxpayers, :phone, :string
  end
end
