#
#
class DefaultSensorBuilderService

  def initialize( index, setpoint_type = :static )
    attr = { sensor_index: index, setpoint_type: setpoint_type }
    p attr
    @sensor = Sensor.new attr
  end

  def sensor
    @sensor
  end
end

