class TaxpayerPhones < ActiveRecord::Migration
  def change
    create_table :taxpayer_phones do |t|
      t.references :taxpayer, index: true, foreign_key: true
      t.string :phone

      t.timestamps null: false
     end  
  end
end
