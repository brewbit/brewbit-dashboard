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

  has_many :sensor_settings, dependent: :destroy
  has_many :output_settings, dependent: :destroy

  validates :name, length: { maximum: 100 }
end
