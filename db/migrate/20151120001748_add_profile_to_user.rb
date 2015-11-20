class AddProfileToUser < ActiveRecord::Migration
  def change
  	add_column :users, :profile, :integer
  end
end
