module Brewbit
  module Api
    module V1
      class ControllerSettingsController < ApiController
        respond_to :json

        def create
          session_action = params.delete(:session_action) || 1
          params[:name] = "Device-Initiated Session" if params[:name].blank?

          if session_action == 0 # create new session
            session = create_session( @device, session_params )
          else # update current session
            session = update_session( @device, session_params )
          end

          if session.save
            @message = 'success'
          else
            @message = "Could not save session: #{session.errors.full_messages}"
            render :error, status: 400
          end
        end

        private
        
        def update_session(device, settings)
          current_session = device.active_session_for settings[:sensor_index]
          if current_session
            current_session.attributes = settings
            current_session
          else
            create_session(device, settings)
          end
        end
        
        def create_session(device, settings)
          current_session = device.active_session_for settings[:sensor_index]
          if current_session
            current_session.active = false
            current_session.save!
          end

          device_session_params = {
            name: settings[:name],
            device_id: device.id,
            sensor_index: settings[:sensor_index],
            setpoint_type: settings[:setpoint_type],
            static_setpoint: settings[:static_setpoint],
            temp_profile_id: settings[:temp_profile_id],
            output_settings_attributes: []
          }

          unless settings[:output_settings].nil?
            settings[:output_settings].each do |output_setting|
              device_session_params[:output_settings_attributes] << {
                output_index: output_setting[:index],
                function: output_setting[:function],
                cycle_delay: output_setting[:cycle_delay]
              }
            end
          end

          device_session = DeviceSession.new(device_session_params)
          device_session.active = true

          device_session
        end

        def session_params
          begin
            [:sensor_index, :setpoint_type].each do |param|
              params.require(param)
            end

            if DeviceSession::SETPOINT_TYPE[:static] == params[:setpoint_type]
              params.require(:static_setpoint)
            else
              params.require(:temp_profile_id)
            end

            unless params[:output_settings].nil?
              params[:output_settings].each do |output_setting|
                validate_output_setting( output_setting )
              end
            end
          rescue ActionController::ParameterMissing => e
            puts e.inspect, $@
            @message = e.message
            render :error, status: 400
          else
            params.permit(:session_action, :name, :sensor_index, :setpoint_type, :static_setpoint, :temp_profile_id, output_settings: [ :index, :function, :cycle_delay ])
          end
        end

        def validate_output_setting( output_setting )
          output_setting.require(:index)
          output_setting.require(:function)
          output_setting.require(:cycle_delay)
        end
      end
    end
  end
end

