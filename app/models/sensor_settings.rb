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

  has_many :readings, -> { order 'created_at ASC' }, class_name: 'SensorReading', foreign_key: 'sensor_settings_id'
  belongs_to :temp_profile

  default_scope include: [:sensor, :readings]

  SETPOINT_TYPE = { static: 0, temp_profile: 1 }

  def static_setpoint(scale = 'F')
    case scale
    when 'F'
      read_attribute( :static_setpoint )
    when 'C'
      fahrenheit_to_celcius( read_attribute(:static_setpoint) )
    else
      read_attribute( :static_setpoint )
    end
  end

  def static_setpoint=(value)
    scale = sensor.try( :device ).try( :user ).try( :temperature_scale )

    case scale
    when 'F'
      write_attribute( :static_setpoint, value )
    when 'C'
      write_attribute( :static_setpoint, celcius_to_fahrenheit(value) )
    else
      write_attribute( :static_setpoint, value )
    end
  end

  private

  def fahrenheit_to_celcius(degrees)
    (degrees.to_f - 32) / 1.8
  end

  def celcius_to_fahrenheit(degrees)
    degrees.to_f * 1.8 + 32
  end
end
