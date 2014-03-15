# Attributes:
# * device_id [integer] - - Which device it belongs to
# * output_id [integer] - - belongs to :output
# * sensor_type [string] - - First or Second sensor
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Sensor < ActiveRecord::Base
  belongs_to :device

  has_many :outputs
  has_many :sensor_readings

  TYPES = { one: 'one', two: 'two' }
  READING_READING_INTERVAL = 5.minutes

  validates :sensor_type, presence: true, inclusion: { in: TYPES.values }

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
