# Attributes:
# * device_id [integer] - - Which device it belongs to
# * sensor_index [integer] - - First or Second sensor
# * setpoint_type [integer] - - Static setpoint or temp profile
# * static_setpoint [float] - - The static setpoint value
# * temp_profile_id [integer] - - The active temp profile
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Sensor < ActiveRecord::Base
  belongs_to :device

  has_many :outputs
  has_many :readings, -> { order 'created_at ASC' }, class_name: 'SensorReading', foreign_key: 'sensor_id', dependent: :destroy
  belongs_to :temp_profile

  SETPOINT_TYPE = { static: 0, temp_profile: 1 }
  READING_READING_INTERVAL = 5.minutes


  def setpoint_type
    SETPOINT_TYPE.key(read_attribute(:setpoint_type))
  end

  def setpoint_type=(s)
    write_attribute(:setpoint_type, SETPOINT_TYPE[s])
  end

  def current_reading
    reading = self.readings.order('created_at').try( :last )
    return nil unless reading

    if last_expected_reading_reading_time > reading.created_at
      nil
    else
      reading.try( :value )
    end
  end

  private

  def last_expected_reading_reading_time
    Time.now.utc - READING_READING_INTERVAL
  end
end
