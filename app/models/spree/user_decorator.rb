module Spree
  User.class_eval do
    after_create :set_default_role
    
    has_many :devices, class_name: "Devices"
    
    def set_default_role
      self.spree_roles << Spree::Role.find_or_create_by(name: "user")
    end
  end
end
