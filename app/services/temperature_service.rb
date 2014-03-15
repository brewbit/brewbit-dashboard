
module TemperatureService

  class UnknownSensor < Exception ; end
  class UnknownDevice < Exception ; end

  def self.record( temperature, device, sensor_id )

    raise UnknownDevice if device.blank? || device.class != Device

    sensor = find_sensor( device, sensor_id )

    attr = {
      value: temperature,
      sensor_id: sensor.id
    }

    device.temperatures.create attr
  end

  private

  def self.find_sensor( device, sensor_id )
    sensors = { 0 => 'one', 1 => 'two' }

    sensor = "sensor_#{sensors[sensor_id]}"
    
    if device.respond_to? sensor.to_sym
      return device.send( sensor )
    else
      raise UnknownSensor
    end
  end
end

