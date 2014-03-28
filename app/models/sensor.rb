# Attributes:
# * device_id [integer] - - Which device it belongs to
# * sensor_index [integer] - - First or Second sensor
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Sensor < ActiveRecord::Base
  belongs_to :device

  has_many :output_settings, -> { order 'created_at ASC' }
  has_many :settings, -> { order 'created_at ASC' }, class_name: 'SensorSettings'
  has_many :readings, -> { order 'created_at ASC' }, class_name: 'SensorReading', foreign_key: 'sensor_id', dependent: :destroy

  SETPOINT_TYPE = { static: 0, temp_profile: 1 }
  
  def current_settings
    device.current_command.sensor_settings.find_by sensor: self
  end
  
  def controlled_outputs
    output_settings = OutputSettings.where(device_command: device.current_command, sensor: self)
    output_settings ? output_settings.collect { |os| os.output } : nil
  end
end
