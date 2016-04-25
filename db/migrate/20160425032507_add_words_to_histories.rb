class AddWordsToHistories < ActiveRecord::Migration
  def change
  	add_reference :histories, :word, index: true, foreign_key: true
  end
end
