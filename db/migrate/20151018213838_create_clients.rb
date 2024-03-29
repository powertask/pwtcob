class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :cnpj
      t.string :zipcode
      t.string :state
      t.string :city
      t.string :address
      t.string :complement
      t.string :neighborhood
      t.string :phone
      t.string :email
      t.decimal :fee, precision: 5, scale: 2

      t.references :unit

      t.timestamps null: false

    end
  end
end
