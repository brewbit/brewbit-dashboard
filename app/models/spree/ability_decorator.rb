class AbilityDecorator
  include CanCan::Ability

  def initialize(user)
    if user.respond_to?(:has_spree_role?) && user.has_spree_role?('user')
      can :start_activate, Device
      can :activate, Device, :user => nil
      can [:index, :show, :edit, :update, :destroy], Device, :user => user
    elsif user.respond_to?(:has_spree_role) && user.has_spree_role('admin')
      can :create, Device
    end
  end
end

Spree::Ability.register_ability(AbilityDecorator)
