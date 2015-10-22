class AddColumnsToTaxpayers < ActiveRecord::Migration
  def change
    add_reference :taxpayers, :client, index: true, foreign_key: true
    add_column :taxpayers, :cnpj, :string
    add_column :taxpayers, :origin_code, :integer
  end
end
