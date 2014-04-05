require 'protobuf_messages/messages'

module ProtobufMessages::Builder

  def self.build( type, data )
    case type
    when ProtobufMessages::ApiMessage::Type::ACTIVATION_NOTIFICATION
      return build_activation_notification data
    when ProtobufMessages::ApiMessage::Type::ACTIVATION_TOKEN_RESPONSE
      return build_activation_token_response data
    when ProtobufMessages::ApiMessage::Type::AUTH_RESPONSE
      return build_auth_response data
    when ProtobufMessages::ApiMessage::Type::FIRMWARE_DOWNLOAD_RESPONSE
      return build_firmware_download_response data
    when ProtobufMessages::ApiMessage::Type::FIRMWARE_UPDATE_CHECK_RESPONSE
      return build_firmware_update_check_response data
    when ProtobufMessages::ApiMessage::Type::DEVICE_SETTINGS_NOTIFICATION
      return build_device_settings_notification data
    end
  end

  private

  def self.build_activation_notification( auth_token )
    message = ProtobufMessages::ApiMessage.new
    message.type = ProtobufMessages::ApiMessage::Type::ACTIVATION_NOTIFICATION
    message.activationNotification = ProtobufMessages::ActivationNotification.new
    message.activationNotification.auth_token = auth_token

    message
  end

  def self.build_activation_token_response( activation_token )
    message = ProtobufMessages::ApiMessage.new
    message.type = ProtobufMessages::ApiMessage::Type::ACTIVATION_TOKEN_RESPONSE
    message.activationTokenResponse = ProtobufMessages::ActivationTokenResponse.new
    message.activationTokenResponse.activation_token = activation_token

    message
  end

  def self.build_auth_response( authenticated )
    message = ProtobufMessages::ApiMessage.new
    message.type = ProtobufMessages::ApiMessage::Type::AUTH_RESPONSE
    message.authResponse = ProtobufMessages::AuthResponse.new
    message.authResponse.authenticated = authenticated

    message
  end

  def self.build_firmware_download_response( data )
    message = ProtobufMessages::ApiMessage.new
    message.type = ProtobufMessages::ApiMessage::Type::FIRMWARE_DOWNLOAD_RESPONSE
    message.firmwareDownloadResponse = ProtobufMessages::FirmwareDownloadResponse.new
    message.firmwareDownloadResponse.offset = data[:offset]
    message.firmwareDownloadResponse.data = data[:chunk]

    message
  end

  def self.build_firmware_update_check_response( data )
    message = ProtobufMessages::ApiMessage.new
    message.type = ProtobufMessages::ApiMessage::Type::FIRMWARE_UPDATE_CHECK_RESPONSE
    message.firmwareUpdateCheckResponse = ProtobufMessages::FirmwareUpdateCheckResponse.new
    message.firmwareUpdateCheckResponse.update_available = data[:update_available]
    message.firmwareUpdateCheckResponse.version = data[:version]
    message.firmwareUpdateCheckResponse.binary_size = data[:binary_size]

    message
  end

  def self.build_device_settings_notification( data )
    message = ProtobufMessages::ApiMessage.new
    message.type = ProtobufMessages::ApiMessage::Type::DEVICE_SETTINGS_NOTIFICATION
    message.deviceSettingsNotification = ProtobufMessages::DeviceSettingsNotification.new
    message.deviceSettingsNotification.name = data[:name]

    message.deviceSettingsNotification.output = []
    data[:outputs].each do |o|
      output = ProtobufMessages::OutputSettings.new
      output.id = o[:index]
      output.function = o[:function]
      output.cycle_delay = o[:cycle_delay]
      output.trigger_sensor_id = o[:sensor_index]
      output.output_mode = o[:output_mode]
      message.deviceSettingsNotification.output << output
    end

    message.deviceSettingsNotification.sensor = []
    data[:sensors].each do |s|
      sensor = ProtobufMessages::SensorSettings.new
      sensor.id = s[:index]
      sensor.setpoint_type = s[:setpoint_type]

      case sensor.setpoint_type
      when ProtobufMessages::SensorSettings::SetpointType::STATIC
        sensor.static_setpoint = s[:static_setpoint]
      when ProtobufMessages::SensorSettings::SetpointType::TEMP_PROFILE
        sensor.temp_profile_id = s[:temp_profile_id]
      end
      message.deviceSettingsNotification.sensor << sensor
    end

    message.deviceSettingsNotification.temp_profiles = []
    data[:temp_profiles].each do |s|
      temp_profile = ProtobufMessages::TempProfile.new
      temp_profile.id          = s[:id]
      temp_profile.name        = s[:name]
      temp_profile.start_value = s[:start_value]
      temp_profile.steps       = []
      s[:steps].each do |st|
        temp_profile_step = ProtobufMessages::TempProfileStep.new
        temp_profile_step.duration = st[:duration]
        temp_profile_step.value    = st[:value]
        temp_profile_step.type     = st[:type]
        
        temp_profile.steps << temp_profile_step
      end

      message.deviceSettingsNotification.temp_profiles << temp_profile
    end

    message
  end
end

