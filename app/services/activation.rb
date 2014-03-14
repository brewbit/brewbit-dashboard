module Activation

  def self.start( device_id )
    device = Device.where( hardware_identifier: device_id ).first

    unless device
      token = create_token
      device = DefaultDeviceBuilderService.new( token, device_id ).device

      device.outputs << build_outputs
      device.probes << build_probes
    end

    device
  end

  def self.user_activates_device( user, device )
    if user.blank? || device.blank?
      return
    end

    device.user = user

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

  def self.create_token
    SecureRandom.hex( 3 )
  end


  def self.build_outputs
    output_right = DefaultOutputBuilderService.new.output
    output_left = DefaultOutputBuilderService.new( Output::FUNCTIONS[:cold], Output::TYPES[:left] ).output

    [ output_right, output_left ]
  end

  def self.build_probes
    probe_one = DefaultProbeBuilderService.new.probe
    probe_two = DefaultProbeBuilderService.new( Probe::TYPES[:two] ).probe

    [ probe_one, probe_two ]
  end
end

