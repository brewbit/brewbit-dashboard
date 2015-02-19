module Brewbit
  class DeviceSessionsController < ApplicationController
    layout 'brewbit/layouts/devices'
    before_action :authorize_action

    # GET /sessions
    def index
      @device_sessions = @device.sessions.where(active: false).order( 'created_at DESC' )
    end

    # GET /sessions/1
    def show
    end

    # GET /sessions/1/poll
    def poll
      render json: @device_session.new_readings(params.require(:pos).to_i)
    end

    # GET /sessions/new
    def new
      @device_session = Defaults.build_device_session @device, brewbit_current_user.temperature_scale
    end

    # GET /sessions/1/edit
    def edit
      populate_output_settings
      @active_session_output_info = @active_session_output_info.except(@device_session.sensor_index)
    end

    # PUT/PATCH /sessions/1
    def update
      begin
        DeviceSession.transaction do
          # ensure that the last modified timestamp is updated even if only dependencies
          # will be changing with this update
          @device_session.touch
          
          @device_session.attributes = device_session_params
          @device_session.save!

          DeviceService.send_session @device, @device_session
        end
      rescue ActiveRecord::RecordInvalid => invalid
        populate_output_settings
        flash[:error] = invalid.record.errors.full_messages.to_sentence
        render action: 'edit'
      rescue => e
        puts $!.inspect, $@

        logger.debug e.inspect

        populate_output_settings
        flash[:error] = 'Session could not be sent to the device.'
        render action: 'edit'
      else
        redirect_to @device, notice: 'Session was successfully updated.'
      end
    end

    # POST /sessions
    def create
      begin
        DeviceSession.transaction do
          # create the new session, but don't save it yet because we need to
          # find and deactivate the old session first
          @device_session = DeviceSession.new(device_session_params)
          @device_session.active = true

          # deactivate old session
          old_session = @device.active_session_for @device_session.sensor_index
          if old_session
            old_session.active = false
            old_session.save!
          end

          # save the new session
          @device_session.save!

          DeviceService.send_session @device, @device_session
        end
      rescue ActiveRecord::RecordInvalid => invalid
        @device_session = reset_device_session_on_error

        flash[:error] = invalid.record.errors.full_messages.to_sentence
        render action: 'new'
      rescue => e
        puts $!.inspect, $@

        logger.debug e.inspect

        @device_session = reset_device_session_on_error
        flash[:error] = 'Session could not be sent to the device.'
        render action: 'new'
      else
        redirect_to @device, notice: 'Session was successfully sent.'
      end
    end

    # DELETE /sessions/1
    def destroy
      @device_session.destroy
      redirect_to device_sessions_path, notice: 'Session was successfully destroyed.'
    end

    def stop_session
      begin
        DeviceSession.transaction do
          empty_session = @device_session.clone
          empty_session.output_settings = []

          @device_session.active = false
          @device_session.save!
          DeviceService.send_session @device, empty_session
        end

        flash[:notice] = 'Session was successfully stopped.'
        redirect_to @device
      rescue => exception
        logger.debug "--- #{exception.inspect}"
        flash[:error] = 'Session could not be stopped because the device is not connected.'
        redirect_to @device
      end
    end

    private
      def authorize_action
        @device = Device.find(params[:device_id])
        @active_session_output_info = @device.active_session_output_info
        
        unless ['new', 'create', 'index'].include? action_name
          @device_session = @device.sessions.find(params[:id])
          @token_authenticated = (action_name == 'show' || action_name == 'poll') && params[:token] && @device_session.access_token == params[:token]
        end
        
        user = brewbit_current_user
        @user_authenticated = user && @device.user == user
        
        unless @user_authenticated or @token_authenticated
          flash[:error] = "You don't have access to that resource"
          redirect_to '/'
        end
      end

      # Only allow a trusted parameter "white list" through.
      def device_session_params
        params.require(:device_session).permit(
          :name, :device_id, :sensor_index, :setpoint_type, :static_setpoint, :temp_profile_id, :temp_profile_completion_action, :temp_profile_start_point, :high_temp_threshold, :low_temp_threshold, :comms_loss_threshold,
          output_settings_attributes: [:id, :output_index, :function, :cycle_delay, :_destroy])
      end

      def populate_output_settings
        # Add any missing output settings objects so they appear on the edit form      
        (0...@device.output_count).each do |output_index|
          if @device_session.output_settings.none?{|os| os.output_index == output_index}
            Defaults.build_output_settings( @device_session, output_index, OutputSettings::FUNCTIONS[:heating] )
          end
        end
      end

      def reset_device_session_on_error
        dsp = device_session_params
        dsp[:output_settings_attributes].each {|id, attrs| attrs.delete '_destroy' }
        DeviceSession.new(dsp)
      end
  end
end
