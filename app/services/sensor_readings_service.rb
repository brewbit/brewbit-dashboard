
module SensorReadingsService

  class UnknownSensor < Exception ; end
  class UnknownDevice < Exception ; end

  def self.record( device, sensor_index, reading, setpoint, timestamp )
    session = device.active_session_for(sensor_index)
    if session
      session.last_reading = reading
      session.last_setpoint = setpoint
      session.save
      
      # manually touch to ensure that the updated_at is updated even if
      # the new reading/setpoint is identical to the previous
      session.touch
      
      timestamp ||= Time.now.to_i
      File.open("public/readings/#{session.uuid}.csv", 'a') do |f|
        f.write("#{timestamp * 1000},#{reading},#{setpoint}\n")
      end
    end
  end
end

