class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :unit
  belongs_to :employee

  has_many :histories
  has_many :contracts
  
  enum profile: [:admin, :user, :client]

end
