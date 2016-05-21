class AddClientToCna < ActiveRecord::Migration
  def change
  	add_reference :cnas, :client, index: true, foreign_key: true
  end
end
