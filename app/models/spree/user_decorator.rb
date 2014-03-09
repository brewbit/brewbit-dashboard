module Spree
  User.class_eval do
    has_many :devices, class_name: "Devices"
  end
end
