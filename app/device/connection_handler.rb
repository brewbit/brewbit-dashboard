require 'singleton'

#
# Stores WebSocket connections and associates them
# with the device's hardware ID
#
class ConnectionHandler
  include Singleton

  @@connections = {}

  def connection_opened( socket )
    Rails.logger.info "Connected: #{socket_id(socket)}"
    @@connections[socket_id(socket)] = socket
    ConnectionManager.init_connection socket
  end

  def on_message( socket, event )
    Rails.logger.info "Received: #{event.data.inspect}"
    # TODO add rescue and logging
    ProtobufMessages::Handler.handle( event.data, socket )
  end

  def close_connection( socket, event )
    Rails.logger.info [:close, socket_id(socket), event.code, event.reason]
    delete( socket )
  end

  def self.get_socket_for_device( id )
    socket_id = ConnectionManager.get_socket_id( id )
    @@connections[socket_id]
  end

  def self.connections
    @@connections
  end

  private

  def socket_id( socket )
    socket.object_id.to_s
  end

  def get_socket( id )
    @@connections[id]
  end

  def delete( socket )
    @@connections.delete socket_id(socket)
    ConnectionManager.remove_connection socket
    socket = nil
  end
end

