class AddClientToHistory < ActiveRecord::Migration
  def change
  	add_reference :histories, :client, index: true, foreign_key: true
  end
end
