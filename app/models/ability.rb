class Ability
  include CanCan::Ability

  def initialize(user)

    return if user.profile.nil?

    can :manage, :all if user.admin?

    can :manage, Home if user.user?
    can :manage, Taxpayer 
    can :manage, History
    can :manage, :Contract
    
  end
end
