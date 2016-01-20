class AddEmployeeToTaxpayer < ActiveRecord::Migration
  def change
    add_reference :taxpayers, :employee, index: true, foreign_key: true
  end
end
