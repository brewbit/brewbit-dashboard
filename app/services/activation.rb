require 'protobuf_messages/messages'

module Activation

  def self.start( device_id )
    device = Device.where( hardware_identifier: device_id ).first

    unless device
      token = create_token
      device = DefaultDeviceBuilderService.new( token, device_id ).device

      device.outputs << build_outputs
      device.sensors << build_sensors
    end

    device
  end

  def self.user_activates_device( user, activation_token )
    raise 'Invalid user specified' if user.blank?
    raise 'Invalid activation token specified' if activation_token.blank?

    device = Device.find_by activation_token: activation_token
    raise 'A device with that activation token could not be found.' if !device
    raise 'That device is already activated.' if device.user

    device.user = user
    raise 'Something went wrong...' if !device.save
    
    begin
      send_activation_notification device
    rescue Exception => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace.join("\n\t")
      
      # invalidate the activation
      device.user = nil
      device.save
      
      raise 'The device must be connected during activation'
    end
    
    device
  end

  def self.finish!( device )
    if device.user.blank? || device.activated?
      return
    end

    device.activate
    device.save

    device.user.authentication_token
  end

  private
  
  def self.send_activation_notification( device )
    type = ProtobufMessages::ApiMessage::Type::ACTIVATION_NOTIFICATION
    auth_token = device.user.authentication_token
    message = ProtobufMessages::Builder.build( type, auth_token )

    connection = DeviceConnection.find_by_device_id device.hardware_identifier
    connection.authenticate( auth_token )
    
    ProtobufMessages::Sender.send( message, connection )
  end

  def self.create_token
    SecureRandom.hex( 3 )
  end


  def self.build_outputs
    output_right = DefaultOutputBuilderService.new.output
    output_left = DefaultOutputBuilderService.new( Output::FUNCTIONS[:cold], Output::TYPES[:left] ).output

    [ output_right, output_left ]
  end

  def self.build_sensors
    sensor_one = DefaultSensorBuilderService.new.sensor
    sensor_two = DefaultSensorBuilderService.new( Sensor::TYPES[:two] ).sensor

    [ sensor_one, sensor_two ]
  end
end

