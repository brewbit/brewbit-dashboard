#
#
class DefaultSensorBuilderService

  def initialize( index )
    attr = { sensor_index: index }
    @sensor = Sensor.new attr
  end

  def sensor
    @sensor
  end
end

