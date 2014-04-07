# == Schema Information
#
# Table name: devices
#
# Attributes:
# * activation_token [string] - - Activation token to be used for this device
# * hardware_identifier [string] - - Hardware ID to be used for API calls
# * name [string] - - Device name
# * user_id [integer] - - belongs to :user
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time

class Device < ActiveRecord::Base
  belongs_to :user, class_name: "Spree::User"

  has_many :sensors, -> { order('sensor_index ASC') }, dependent: :destroy
  has_many :outputs, -> { order('output_index ASC') }, dependent: :destroy
  has_many :commands, -> { order('created_at DESC') }, class_name: 'DeviceCommand', dependent: :destroy, foreign_key: 'device_id'

  validates :name, presence: true, length: { maximum: 100 }
  validates :hardware_identifier, uniqueness: { case_sensitive: true }

  accepts_nested_attributes_for :outputs, :sensors

  def current_command
    commands.first
  end

  def activated?
    !user.blank? && activation_token.blank?
  end

  def activate(user)
    self.user = user
    self.activation_token = ''
    
    DeviceService.send_activation_notification device
  end
end
