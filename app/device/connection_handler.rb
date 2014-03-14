require 'singleton'

#
# Stores WebSocket connections and associates them
# with the device's hardware ID
#
class ConnectionHandler
  include Singleton

  @@device_to_socket = {}
  @@socket_to_device = {}

  def connection_opened( socket, device_id )
    Rails.logger.info "Connected: socket id: #{socket_id(socket)}, device id: #{device_id}"
    
    @@socket_to_device[socket_id(socket)] = device_id
    @@device_to_socket[device_id] = socket
  end

  def on_message( socket, event )
    Rails.logger.info "Received: #{event.data.inspect}"
    # TODO add rescue and logging
    device_id = @@socket_to_device[socket_id(socket)]
    ProtobufMessages::Handler.handle( event.data, device_id )
  end

  def close_connection( socket, event )
    Rails.logger.info [:close, socket_id(socket), event.code, event.reason]
    delete( socket )
  end
  
  def self.get_socket( device_id )
    @@device_to_socket[device_id]
  end

  private

  def socket_id( socket )
    socket.object_id.to_s
  end

  def delete( socket )
    @@device_to_socket.delete @@socket_to_device[socket_id(socket)]
    @@socket_to_device.delete socket_id(socket)
    socket = nil
  end
end

