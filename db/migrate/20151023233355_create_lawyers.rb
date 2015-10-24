class CreateLawyers < ActiveRecord::Migration
  def change
    create_table :lawyers do |t|
      t.string :name
      t.string :lawyer_code
      t.string :cpf
      t.string :cnpj
      t.string :phone
      t.string :zipcode
      t.string :address
      t.string :state
      t.string :city
      t.string :complement
      t.string :neighborhood
      t.string :email

      t.timestamps null: false
    end
  end
end
