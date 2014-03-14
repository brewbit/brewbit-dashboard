require 'singleton'

#
# Stores WebSocket connections and associates them
# with the device's hardware ID
#
class ConnectionHandler
  include Singleton

  def connection_opened( socket, device_id )
    Rails.logger.info "Connected: socket id: #{socket_id(socket)}, device id: #{device_id}"
    
    DeviceConnection.new( device_id, socket )
  end

  def on_message( socket, event )
    Rails.logger.info "Received: #{event.data.inspect}"
    # TODO add rescue and logging
    connection = DeviceConnection.find_by_socket socket
    ProtobufMessages::Handler.handle( event.data, connection )
  end

  def close_connection( socket, event )
    Rails.logger.info [:close, socket_id(socket), event.code, event.reason]

    connection = DeviceConnection.find_by_socket socket
    connection.delete
  end
  
  private

  def socket_id( socket )
    socket.object_id.to_s
  end
end

