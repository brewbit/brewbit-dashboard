
class SystemNotificationMessage
  attr_accessor :type, :data

  CHANNEL = 'system'

  TYPES = {
    set_device_id: 'set_device_id'
  }

  def build( type, options = {} )

    case type
    when TYPES[:set_device_id]
      build_device_id options
    end
  end

  def serialize
    self.to_json
  end

  def deserialize( message )
    m = JSON.parse( message ).symbolize_keys

    @type = m[:type]

    case @type
    when TYPES[:set_device_id]
      @data = get_device_id_data( m[:data] )
    end
  end

  private

  def build_device_id( options )
    @type = TYPES[:set_device_id]

    device_id = options[:device_id]
    socket_id = options[:socket_id]
    @data = { device_id: device_id, socket_id: socket_id }
  end

  def get_device_id_data( data )
    {
      device_id: data['device_id'],
      socket_id: data['socket_id']
    }
  end
end

