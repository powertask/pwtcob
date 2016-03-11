class AddColumnsToTicket < ActiveRecord::Migration
  def change
  	add_column :tickets, :status, :boolean
  	add_column :tickets, :paid_at, :date
  	add_column :tickets, :paid_amount, :float
  end

end
