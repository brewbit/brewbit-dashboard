class Device < ActiveRecord::Base
  belongs_to :user, class_name: "Spree::User"
end
