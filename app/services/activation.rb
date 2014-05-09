module Activation

  def self.start( device_id )
    device = Device.where( hardware_identifier: device_id ).first

    unless device
      token = create_token
      device = Defaults.build_device( token, device_id )
    end

    device
  end

  def self.user_activates_device( user, activation_token )
    raise 'Invalid user specified' if user.blank? || user.nil?
    raise 'Invalid activation token specified' if activation_token.blank?

    device = Device.find_by activation_token: activation_token
    raise 'A device with that activation token could not be found.' if !device
    raise 'That device is already activated.' if device.user != user

    begin
      device.name = 'Model-T'
      if user.devices.count > 0
        device.name += " (#{user.devices.count})"
      end
      device.user = user
      device.save!
      
      DeviceService.send_activation_notification device
    rescue Exception => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace.join("\n\t")

      # invalidate the activation
      device.user = nil
      device.save

      raise 'Device activation could not be completed.'
    end

    device
  end

  private

  def self.create_token
    SecureRandom.hex( 3 )
  end
end

