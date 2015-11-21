class AddCityToTaxpayer < ActiveRecord::Migration
  def change
  	add_column :taxpayers, :city_id, :integer
  end
end
