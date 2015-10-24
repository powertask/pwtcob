class AddUnitToLawyer < ActiveRecord::Migration
  def change
    add_reference :lawyers, :unit, index: true, foreign_key: true
  end
end
