# == Schema Information
#
# Table name: device_commands
#
# Attributes:
# * name [string] - - Device name
# * device_id [integer] - - belongs to :device
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time

class DeviceCommand < ActiveRecord::Base
  belongs_to :device

  has_many :sensor_settings, class_name: 'SensorSettings', dependent: :destroy
  has_many :output_settings, class_name: 'OutputSettings', dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  
  accepts_nested_attributes_for :sensor_settings, :output_settings
end
