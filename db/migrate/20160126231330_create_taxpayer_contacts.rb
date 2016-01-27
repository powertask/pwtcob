class CreateTaxpayerContacts < ActiveRecord::Migration
  def change
    create_table :taxpayer_contacts do |t|
      t.references :taxpayer, index: true, foreign_key: true
      t.string :name
      t.string :description
      t.string :phone
      t.string :email

      t.timestamps null: false
    end
  end
end
