
module SensorReadingsService

  class UnknownSensor < Exception ; end
  class UnknownDevice < Exception ; end

  def self.record( device, sensor_index, reading, setpoint )

    # raise UnknownDevice if device.blank? || device.class != Device

    sensor = device.sensors.find_by sensor_index: sensor_index
    if sensor
      File.open("public/readings/#{sensor.current_settings.id}.csv", 'a') do |f|
        f.write("#{Time.now.to_i * 1000},#{reading},#{setpoint}\n")
      end
    end
  end
end

