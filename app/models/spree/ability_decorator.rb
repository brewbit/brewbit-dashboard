class AbilityDecorator
  include CanCan::Ability

  def initialize(user)
    if user.respond_to?(:has_spree_role?) && user.has_spree_role?('user')
      can :start_activate, Device
      can :activate, Device, :user => nil
      can [:index, :show, :edit, :update], Device, :user => user
      
      can [:show, :edit, :update], Sensor, :device => { :user => user }
      
      can :create, TempProfile
      can :manage, TempProfile, :user => user
    end
  end
end

Spree::Ability.register_ability(AbilityDecorator)
