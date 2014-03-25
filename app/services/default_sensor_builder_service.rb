#
#
class DefaultSensorBuilderService

  def initialize( device, index, setpoint_type = Sensor::SETPOINT_TYPE[:static], static_setpoint = 68 )
    attr = { sensor_index: index }
    sensor = Sensor.new attr
    device.sensors << sensor
    
    attr = {
      setpoint_type: setpoint_type,
      static_setpoint: static_setpoint
    }
    sensor_settings = SensorSettings.new attr
    sensor.settings << sensor_settings
  end
end

