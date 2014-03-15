# == Schema Information
#
# Table name: devices
#
# Attributes:
# * activation_token [string] - - Activation token to be used for this device
# * hardware_identifier [string] - - Hardware ID to be used for API calls
# * name [string] - - Device name
# * signal_strength [decimal] - - WiFi signal strength in percent
# * user_id [integer] - - belongs to :user
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time

class Device < ActiveRecord::Base
  belongs_to :user, class_name: "Spree::User"

  has_many :sensors, dependent: :destroy
  has_many :outputs, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :hardware_identifier, uniqueness: { case_sensitive: true }

  def activated?
    !user.blank? && activation_token.blank?
  end

  def activate
    self.activation_token = ''
  end
end
