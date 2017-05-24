class Ability
  include CanCan::Ability

  def initialize(user)

    return if user.profile.nil?

    can :manage, :all if user.admin?

    can :manage, Ticket  if user.user?

    can :manage, Taxpayer  if user.user?
    can :read, Taxpayer  if user.client?

    can :manage, Contract if user.user?
    can :manage, Proposal if user.user?
    
    can :manage, Contract if user.email == 'andreia@faesc.com.br'
    
    can :read, Contract if user.client?

    can :read, City if user.client?

    can :manage, Home if user.user?

    can :manage, Task if user.user?
    
    can :manage, History if user.user?

    can :manage, Remittance if user.user?
    can :manage, Remittance if user.client?

    can :manage, Discharge if user.client?

    can :manage, BankBillet if user.client?
    can :manage, BankBillet if user.user?

    ## Client permissions
    can :manage, Client if user.admin?
    can :manage, Client if user.user?

    cannot :insert, Client unless user.id == 1
    cannot :new, Client unless user.id == 1

  end
end
