#
# Defaults
#
# name                  - Randomly generated
# hardware_identifier   - <provided>
#
class DefaultDeviceBuilderService
  def initialize( activation_token, hardware_identifier, name = 'Next Great Brew' )

    attr = {
      activation_token: activation_token,
      hardware_identifier: hardware_identifier,
      name: name
    }

    @device = Device.new attr
  end

  def device
    @device
  end
end

