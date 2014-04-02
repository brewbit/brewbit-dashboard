#
# Defaults
#
# name                  - Randomly generated
# hardware_identifier   - <provided>
#
class Defaults
  def self.build_device( activation_token, hardware_identifier, name = 'Model-T' )
    attr = {
      activation_token: activation_token,
      hardware_identifier: hardware_identifier,
      name: "#{name} #{Device.count + 1}"
    }

    device = Device.new attr

    build_sensor( device, 0 )
    build_sensor( device, 1 )
    
    build_output( device, 0 )
    build_output( device, 1 )
    
    build_device_command( device )
    
    device
  end
  
  def self.build_output( device, index )
    attr = {
      device: device,
      output_index: index
    }
    output = Output.new attr
    device.outputs << output
  end
  
  def self.build_sensor( device, index )
    attr = {
      device: device,
      sensor_index: index
    }
    sensor = Sensor.new attr
    device.sensors << sensor
  end
  
  def self.build_device_command( device )
    attr = {
      device: device,
      name: '(default)'
    }
    device_command = DeviceCommand.new attr
    device.commands << device_command
    
    build_sensor_settings( device_command, device.sensors[0] )
    build_sensor_settings( device_command, device.sensors[1] )
    
    build_output_settings( device_command, device.outputs[0], OutputSettings::FUNCTIONS[:heating] )
    build_output_settings( device_command, device.outputs[1], OutputSettings::FUNCTIONS[:cooling] )
    
    device_command
  end
  
  def self.build_sensor_settings( device_command, sensor, setpoint_type = Sensor::SETPOINT_TYPE[:static], static_setpoint = 68 )
    attr = {
      device_command: device_command,
      sensor: sensor,
      setpoint_type: setpoint_type,
      static_setpoint: static_setpoint
    }
    sensor_settings = SensorSettings.new attr
    device_command.sensor_settings << sensor_settings
    sensor.settings << sensor_settings
  end
  
  def self.build_output_settings( device_command, output, function = Output::FUNCTIONS[:heating], cycle_delay = 3 )
    attr = {
      device_command: device_command,
      output: output,
      sensor: output.device.sensors[0],
      function: function,
      cycle_delay: cycle_delay
    }
    output_settings = OutputSettings.new attr
    device_command.output_settings << output_settings
    output.settings << output_settings
  end
end

