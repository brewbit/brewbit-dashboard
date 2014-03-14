#
#
class DefaultProbeBuilderService

  def initialize( type = Probe::TYPES[:one] )
    attr = { probe_type: type }
    @probe = Probe.new attr
  end

  def probe
    @probe
  end
end

