# Attributes:
# * device_command_id [integer] - - Which device command it belongs to
# * sensor_id [integer] - - Which sensor it belongs to
# * setpoint_type [integer] - - Static setpoint or temp profile
# * static_setpoint [float] - - The static setpoint value
# * temp_profile_id [integer] - - The active temp profile
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class SensorSettings < ActiveRecord::Base
  belongs_to :device_command
  belongs_to :sensor

  has_many :readings, -> { order 'created_at ASC' }, class_name: 'SensorReading'
  belongs_to :temp_profile

  SETPOINT_TYPE = { static: 0, temp_profile: 1 }
end
