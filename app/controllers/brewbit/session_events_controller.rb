module Brewbit
  class SessionEventsController < ApplicationController
    before_filter :correct_user
    before_filter :correct_device
    before_filter :correct_device_session

    # POST /devices/1/device_sessions/1/events
    def create
      @device_session.session_events.create event_params
      redirect_to :back
    end
    
    # PATCH/PUT /devices/1/device_sessions/1/events/1
    def update
      redirect_to :back
    end

    # DELETE /devices/1/device_sessions/1/events/1
    def destroy
      redirect_to :back
    end

    private
      def event_params
        params.require(:session_event).permit(:event_type, :timestamp, :note)
      end
      
      def correct_device_session
        @device_session = @device.sessions.find( params[:session_id] )
        redirect_to root_path, error: 'You can only see your own sessions' unless @device_session
      end
      
      def correct_device
        @device = brewbit_current_user.devices.find( params[:device_id] )
        redirect_to root_path, error: 'You can only see your own devices' unless @device
      end

      def correct_user
        # TODO why doesn't this work?
        # redirect_to main_app.login_path unless brewbit_current_user
        redirect_to '/login' unless brewbit_current_user
      end
  end
end
