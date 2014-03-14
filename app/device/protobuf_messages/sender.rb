module ProtobufMessages::Sender

  def self.send( message, socket )
    # TODO schedule in background worker
    send_message message, socket
  end

  private

  def self.serialize_message( message )
    message.encode.to_s.unpack('c*')
  end

  def self.send_message( message, socket )
    data = serialize_message( message )

    Rails.logger.info 'Sending Message'
    Rails.logger.info "    Message: #{message.inspect}"


    # TODO use mutex to lock use of socket?
    socket.send data
  end
end

