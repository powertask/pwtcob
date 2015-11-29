class AddChangeToIndices < ActiveRecord::Migration
  def change
    add_column :indices, :change, :decimal, precision: 10, scale: 4
  end
end
