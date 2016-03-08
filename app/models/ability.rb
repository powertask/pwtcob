class Ability
  include CanCan::Ability

  def initialize(user)

    return if user.profile.nil?

    can :manage, :all if user.admin?

    can :manage, Taxpayer  if user.user?
    can :read, Taxpayer  if user.client?

    can :manage, Contract if user.user?
    can :read, Contract if user.client?

    can :read, City if user.client?

    can :manage, Home if user.user?

    can :manage, History if user.user?

    can :manage, Remittance if user.user?
    can :manage, Remittance if user.client?

    can :manage, Discharge if user.client?
    can :manage, BankBillet if user.client?

    can :manage, BankBillet if user.user?
    
  end
end
