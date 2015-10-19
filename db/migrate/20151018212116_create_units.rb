class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.string :cnpj
      t.string :zipcode
      t.string :state
      t.string :city
      t.string :address
      t.string :complement
      t.string :neighborhood
      t.string :email

      t.timestamps null: false

    end
  end
end
