#
# Defaults
#
# name                  - Randomly generated
# hardware_identifier   - <provided>
#
class DefaultDeviceBuilderService
  def initialize( activation_token, hardware_identifier, name = 'Model-T' )

    attr = {
      activation_token: activation_token,
      hardware_identifier: hardware_identifier,
      name: "#{name} #{Device.count + 1}"
    }

    @device = Device.new attr
  end

  def device
    @device
  end
end

