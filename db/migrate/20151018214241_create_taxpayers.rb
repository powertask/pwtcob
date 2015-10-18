class CreateTaxpayers < ActiveRecord::Migration
  def change
    create_table :taxpayers do |t|
      t.string :name
      t.string :cpf
      t.string :zipcode
      t.string :state
      t.string :city
      t.string :address
      t.string :complement
      t.string :neighborhood
    end
  end
end
