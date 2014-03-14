require 'protobuf_messages/messages'

module ProtobufMessages::Handler

  class MissingDeviceId < Exception ; end
  class MissingAuthToken < Exception ; end
  class MissingProbeData < Exception ; end
  class UnknownDevice < Exception ; end

  def self.handle( msg, socket )
    Rails.logger.info 'Processing Message'
    Rails.logger.info "    Message: #{msg.inspect}"

    message = ProtobufMessages::ApiMessage.decode( msg.pack('c*') )

    case message.type
    when ProtobufMessages::ApiMessage::Type::ACTIVATION_TOKEN_REQUEST
      activation_token_request message, socket
    when ProtobufMessages::ApiMessage::Type::AUTH_REQUEST
      auth_request message, socket
    when ProtobufMessages::ApiMessage::Type::DEVICE_REPORT
      device_report message, socket
    when ProtobufMessages::ApiMessage::Type::FIRMWARE_DOWNLOAD_REQUEST
      firmware_download_request message, socket
    when ProtobufMessages::ApiMessage::Type::FIRMWARE_UPDATE_CHECK_REQUEST
      firmware_update_check_request message, socket
    end
  end

  private

  def self.activation_token_request( message, socket )
    raise MissingDeviceId if message.activationTokenRequest.device_id.blank?

    Rails.logger.info 'Processing Activation Token Request'
    Rails.logger.info "    Message: #{message.inspect}"

    device_id = message.activationTokenRequest.device_id
    device = Activation.start( device_id )
    device.save # TODO: implement error checking around save

    set_device_id_for_socket( device_id, socket )

    type = ProtobufMessages::ApiMessage::Type::ACTIVATION_TOKEN_RESPONSE
    data = device.activation_token
    response_message = ProtobufMessages::Builder.build( type, data )

    send_response response_message, socket
  end

  def self.auth_request( message, socket )
    raise MissingDeviceId if message.authRequest.device_id.blank?
    raise MissingAuthToken if message.authRequest.auth_token.blank?

    Rails.logger.info 'Processing Auth Request'
    Rails.logger.info "    Message: #{message.inspect}"

    device_id = message.authRequest.device_id
    auth_token = message.authRequest.auth_token

    set_device_id_for_socket( device_id, socket )

    authenticated = ConnectionManager.authenticate( socket, auth_token )

    type = ProtobufMessages::ApiMessage::Type::AUTH_RESPONSE
    response_message = ProtobufMessages::Builder.build( type, authenticated )

    send_response response_message, socket
  end

  def self.device_report( message, socket )
    raise MissingProbeData if message.deviceReport.probeReport.blank?

    return if !ConnectionManager.authenticated?( socket )

    Rails.logger.info 'Process Device Report'
    Rails.logger.info "    Message: #{message.inspect}"

    device_id = ConnectionManager.get_device_id( socket )

    device = Device.find_by_hardware_identifier device_id

    raise UnknownDevice if device.blank?

    message.deviceReport.probeReport.each do |probe|
      temperature = probe.value
      probe_id = probe.id
      TemperatureService.record temperature, device, probe_id
    end
  end

  def self.firmware_download_request( message, socket )
    Rails.logger.info 'Process Firmware Download Request'
    Rails.logger.info "    Message: #{message.inspect}"

    return if !ConnectionManager.authenticated?( socket )

    version = message.firmwareDownloadRequest.requested_version

    type = ProtobufMessages::ApiMessage::Type::FIRMWARE_DOWNLOAD_RESPONSE

    firmware = FirmwareVersionManager.get_firmware( version )

    firmware_data = FirmwareSerializer.new( firmware.file )
    total_packets = firmware.size

    firmware_data.each_with_index do |chunk, i|
      offset = i * FirmwareSerializer::CHUNK_SIZE
      data = { offset: offset, chunk: chunk }
      response_message = ProtobufMessages::Builder.build( type, data )
      send_response response_message, socket
    end
  end

  def self.firmware_update_check_request( message, socket )
    Rails.logger.info 'Process Firmware Update Check Request'
    Rails.logger.info "    Message: #{message.inspect}"

    return if !ConnectionManager.authenticated?( socket )

    current_version = message.firmwareUpdateCheckRequest.current_version

    type = ProtobufMessages::ApiMessage::Type::FIRMWARE_UPDATE_CHECK_RESPONSE
    data = {}
    if FirmwareVersionManager.update_available?( current_version )
      update_info = FirmwareVersionManager.get_latest_version_info
      unless update_info.blank?
        data[:update_available] = true
        data[:version] = update_info[:version]
        data[:binary_size] = update_info[:size]
      else
        data[:update_available] = false
      end
    else
      data[:update_available] = false
    end

    response_message = ProtobufMessages::Builder.build( type, data )
    send_response response_message, socket
  end

  private

  def self.send_response( message, socket )
    ProtobufMessages::Sender.send( message, socket )
  end

  def self.set_device_id_for_socket( device_id, socket )
    ConnectionManager.set_device_id( socket, device_id )
  end
end

