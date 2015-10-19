class Unit < ActiveRecord::Base
  validates_presence_of :name

  usar_como_cnpj :cnpj

  has_many :users
  has_many :clients
end
