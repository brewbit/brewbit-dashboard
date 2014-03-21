require 'faye/websocket'
require 'thread'

module WebSocket
  class DeviceServer
    KEEPALIVE_TIME = 15 # in seconds

    def initialize( app )
      @app     = app
      @handler = ConnectionHandler.instance
    end

    def call(env)
      if Faye::WebSocket.websocket?( env )
        ws = Faye::WebSocket.new( env, nil, { ping: KEEPALIVE_TIME } )

        ws.on :open do |event|
          @handler.connection_opened ws, env['HTTP_DEVICE_ID']
        end

        ws.on :message do |event|
          @handler.on_message ws, event
        end

        ws.on :close do |event|
          @handler.close_connection ws, event
        end

        ws.on :error do |event|
          on_error( event )
        end

        ws.rack_response
      else
        @app.call( env )
      end
    end

    private

    def on_error( event )
      p "Error: #{event.data}"
    end
  end
end

