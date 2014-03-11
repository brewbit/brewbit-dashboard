# Attributes:
# * device_id [integer] - - Which device it belongs to
# * output_id [integer] - - belongs to :output
# * probe_type [string] - - First or Second probe
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Probe < ActiveRecord::Base
  belongs_to :device

  has_many :outputs
  has_many :temperatures

  TYPES = { one: 'one', two: 'two' }
  TEMPERATURE_READING_INTERVAL = 5.minutes

  validates :probe_type, presence: true, inclusion: { in: TYPES.values }

  def current_temperature
    temperature = self.temperatures.order('created_at').try( :last )
    return nil unless temperature

    if last_expected_temperature_reading_time > temperature.created_at
      nil
    else
      temperature.try( :value )
    end
  end

  private

  def last_expected_temperature_reading_time
    Time.now.utc - TEMPERATURE_READING_INTERVAL
  end
end
