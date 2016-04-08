class AddDistribuitedAtToTaxpayer < ActiveRecord::Migration
  def change
  	add_column :taxpayers, :distributed_at, :date
  end
end
