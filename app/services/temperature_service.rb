
module TemperatureService

  class UnknownProbe < Exception ; end
  class UnknownDevice < Exception ; end

  def self.record( temperature, device, probe_id )

    raise UnknownDevice if device.blank? || device.class != Device

    probe = find_probe( device, probe_id )

    attr = {
      value: temperature,
      probe_id: probe.id
    }

    device.temperatures.create attr
  end

  private

  def self.find_probe( device, id )
    probes = { 1 => 'one', 2 => 'two' }

    probe = "probe_#{probes[id]}"

    if device.respond_to? probe.to_sym
      return device.send( probe )
    else
      raise UnknownProbe
    end
  end
end

