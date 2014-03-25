#
# Defaults
#
# function          - hot
# output_type       - right
# cycle_delay  - 3 minutes
#
class DefaultOutputBuilderService

  def initialize( device, function = Output::FUNCTIONS[:hot], index = 0, cycle_delay = 3 )
    attr = { output_index: index }
    output = Output.new attr
    device.outputs << output
    
    attr = {
      device_command: device.current_command,
      sensor_settings: device.sensors[0].current_settings,
      function: function,
      cycle_delay: cycle_delay
    }
    output_settings = OutputSettings.new attr
    output.settings << output_settings
  end
end

