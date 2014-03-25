#
#
class DefaultSensorBuilderService

  def initialize( index, setpoint_type = Sensor::SETPOINT_TYPE[:static], static_setpoint = 68 )
    attr = { sensor_index: index, setpoint_type: setpoint_type, static_setpoint: static_setpoint }
    p attr
    @sensor = Sensor.new attr
  end

  def sensor
    @sensor
  end
end

