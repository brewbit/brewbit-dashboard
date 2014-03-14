module ProtobufMessages::Sender

  def self.send( message, device_id )
    # TODO schedule in background worker
    send_message message, device_id
  end

  private

  def self.serialize_message( message )
    message.encode.to_s.unpack('c*')
  end

  def self.send_message( message, device_id )
    data = serialize_message( message )

    Rails.logger.info 'Sending Message'
    Rails.logger.info "    Message: #{message.inspect}"

    socket = ConnectionHandler.get_socket(device_id)
    # TODO use mutex to lock use of socket?
    socket.send data
  end
end

