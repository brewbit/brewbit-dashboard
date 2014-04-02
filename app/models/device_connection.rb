class DeviceConnection
  attr_reader :socket
  attr_reader :device_id
  attr_reader :authenticated
  
  @@connections = []
  
  def self.all
    @@connections
  end
  
  def self.find_by_socket(socket)
    all.detect { |l| l.socket == socket }
  end
  
  def self.find_by_device_id(device_id)
    all.detect { |l| l.device_id == device_id }
  end
  
  def initialize(device_id, socket)
    @device_id = device_id
    @socket = socket
    @authenticated = false
    
    @@connections << self
  end
  
  def device
    Device.find_by hardware_identifier: @device_id
  end
  
  def delete
    @@connections.delete self
    @socket = nil
  end
  
  def authenticate( auth_token )
    user = ApiKey.find_by_access_token( auth_token ).try( :user )

    if device and user and device.user == user
      @authenticated = true
    else
      false
    end
  end
end
