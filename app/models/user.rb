class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :unit

  has_many :histories
  has_many :contracts
  has_many :taxpayers
  
  validates_presence_of :name, :unit_id
  validates_format_of :phone, :with => /\A^[\d]+$\Z/, :message => " - Deve ser um número"

  enum profile: [:admin, :user, :client]

  def self.list(unit)
    self.where("unit_id = ? AND fl_taxpayer = true", unit ).order("name ASC")
  end

  def soft_delete  
    update_attribute(:deleted_at, Time.current)  
  end  

  # ensure user account is active  
  def active_for_authentication?  
    super && !deleted_at  
  end  

  # provide a custom message for a deleted account   
  def inactive_message   
    !deleted_at ? super : :deleted_account  
  end  
  
end
