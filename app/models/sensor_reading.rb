# Attributes:
# * sensor_id [integer] - Sensor that recorded the reading
# * value [float]       - Sensor reading
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class SensorReading < ActiveRecord::Base
  belongs_to :sensor

  validates :value, presence: true, numericality: true
  validates :sensor_id, presence: true

  def as_json( options = {} )
    super( options.merge(
      only: [ :value, :created_at ]
    ))
  end
end

