
class ConnectionManager

  def self.init_connection( socket )
    connection = DeviceConnection.new
    connection.socket_id = socket_id(socket)

    connection.save
  end

  def self.remove_connection( socket )
    connection = DeviceConnection.find_by_socket_id( socket_id(socket) )
    connection.destroy
  end

  def self.set_device_id( socket, device_id )
    connection = DeviceConnection.find_by_socket_id( socket_id(socket) )
    connection.device_id = device_id

    connection.save
  end

  def self.get_socket_id( device_id )
    connection = DeviceConnection.find_by_device_id device_id
    connection.socket_id
  end

  def self.get_device_id( socket )
    connection = DeviceConnection.find_by_socket_id( socket_id(socket) )
    connection.try :device_id
  end

  def self.authenticate( socket, token )
    connection = DeviceConnection.find_by_socket_id( socket_id(socket) )
    user = ApiKey.find_by_access_token( token ).try( :user )

    if user
      device = user.devices.find_by_hardware_identifier( connection.device_id )
    end

    if device
      connection.auth_token = token
      connection.save

      return true
    end

    false
  end

  def self.authenticated?( socket )
    token = DeviceConnection.find_by_socket_id( socket_id(socket) ).try( :auth_token )

    token ? true : false
  end

  private

  def self.socket_id( socket )
    socket.object_id.to_s
  end
end

