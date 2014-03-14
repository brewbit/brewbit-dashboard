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
end

