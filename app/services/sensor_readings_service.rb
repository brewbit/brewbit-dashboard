
module SensorReadingsService

  class UnknownSensor < Exception ; end
  class UnknownDevice < Exception ; end

  def self.record( reading, setpoint, device, sensor_id )

    raise UnknownDevice if device.blank? || device.class != Device

    sensor = device.sensors.find_by sensor_index: sensor_id
    if sensor
      attr = {
        sensor_id: sensor.id,
        value: reading,
        setpoint: setpoint
      }
  
      reading = sensor.readings.create attr
      sensor.current_settings.readings << reading
    end
  end
end

