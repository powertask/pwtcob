class AddClientToTicket < ActiveRecord::Migration
  def change
  	add_reference :tickets, :client, index: true, foreign_key: true
  end
end
