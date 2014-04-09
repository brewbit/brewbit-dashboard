
module DeviceSettingsService

  def self.update( device, settings )

    params = {
      device_id: device.id,
      sensor_settings_attributes: {},
      output_settings_attributes: {}
    }

    params[:name] = settings[:name] if settings[:name].present?

    settings[:outptus].each do |output|
      sensor = device.sensors.where( sensor_index: output[:sensor] )
      o = device.outputs.where( output_index: output[:id] )

      params[:output_settings_attributes][output[:id]] = {
        output_id: o.id,
        sensor_id: sensor.id,
        function: output[:function],
        cycle_delay: output[:cycle_delay],
        output_mode: output[:mode]
      }
    end

    settings[:sensors].each do |sensor|
      s = device.sensors.where( sensor_index: sensor[:id] )
      temp_profile = device.temp_profile.find( sensor[:temp_profile_id] )

      params[:sensor_settings_attributes][sensor[:id]] = {
        sensor_id: s.id,
        setpoint_type: sensor[:setpoint_type],
        static_setpoint: sensor[:static_setpoint],
        temp_profile_id: sensor[:temp_profile_id]
      }
    end

    DeviceCommand.create params
  end
end

