module ProtobufMessages::Sender

  def self.send( message, connection )
    # TODO schedule in background worker
    send_message message, connection
  end

  private

  def self.serialize_message( message )
    message.encode.to_s.unpack('c*')
  end

  def self.send_message( message, connection )
    data = serialize_message( message )

    Rails.logger.info 'Sending Message'
    Rails.logger.info "    Message: #{message.inspect}"

    # TODO use mutex to lock use of socket?
    connection.socket.send data
  end
end

