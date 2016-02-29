class AddFlCorrecaoToUnit < ActiveRecord::Migration
  def change
  	add_column :units, :fl_correcao, :boolean
  end
end
