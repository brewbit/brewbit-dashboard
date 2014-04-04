module Spree
  User.class_eval do

    after_create :set_default_role
    after_create :set_default_temperature_scale

    has_many :devices, dependent: :destroy, class_name: "Device"
    has_many :api_keys, dependent: :destroy, class_name: "ApiKey"
    has_many :temp_profiles, dependent: :destroy, class_name: "TempProfile"

    def set_default_role
      self.spree_roles << Spree::Role.find_or_create_by(name: "user")
    end

    def set_default_temperature_scale
      self.temperature_scale = 'F'
    end

    def authentication_token
      key = self.api_keys.first

      if key.blank?
        key = self.api_keys.create
      end

      key.access_token
    end
  end
end
