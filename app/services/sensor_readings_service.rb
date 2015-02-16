
module SensorReadingsService

  class UnknownSensor < Exception ; end
  class UnknownDevice < Exception ; end

  def self.record( device, sensor_index, reading, setpoint, timestamp, output_status )
    session = device.active_session_for(sensor_index)
    if session
      session.last_reading = reading
      session.last_setpoint = setpoint
      AlertService.check session
      session.save
      
      # manually touch to ensure that the updated_at is updated even if
      # the new reading/setpoint is identical to the previous
      session.touch
      
      output_states = [nil, nil]
      if !output_status.nil?
        output_status.each { |os| output_states[os[:output_index]] = (os[:status] ? 1 : 0) }
      end
      
      timestamp ||= Time.now.to_i
      File.open("public/readings/#{session.uuid}.csv", 'a') do |f|
        f.write("#{timestamp * 1000},#{reading},#{setpoint},#{output_states[0]},#{output_states[1]}\n")
      end
    end
  end

end

