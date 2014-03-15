#
#
class DefaultSensorBuilderService

  def initialize( type = Sensor::TYPES[:one] )
    attr = { sensor_type: type }
    @sensor = Sensor.new attr
  end

  def sensor
    @sensor
  end
end

