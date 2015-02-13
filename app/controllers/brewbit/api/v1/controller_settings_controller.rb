module Brewbit
  module Api
    module V1
      class ControllerSettingsController < ApiController
        respond_to :json

        def create
          sp = session_params
          session_action = sp.delete(:session_action) || 1
          sp[:name] = "Device-Initiated Session" if sp[:name].blank?

          if session_action == 0 # create new session
            session = create_session( @device, sp )
          else # update current session
            session = update_session( @device, sp )
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

          device_session = DeviceSession.new(settings)
          device_session.device = device
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

            unless params[:output_settings_attributes].nil?
              params[:output_settings_attributes].each do |output_setting|
                validate_output_setting( output_setting )
              end
            end
          rescue ActionController::ParameterMissing => e
            puts e.inspect, $@
            @message = e.message
            render :error, status: 400
          else
            params.require(:controller_setting).except(:auth_token, :device_id).permit(:session_action, :name, :sensor_index, :setpoint_type, :static_setpoint, :temp_profile_id, :temp_profile_completion_action, :temp_profile_start_point, output_settings_attributes: [ :output_index, :function, :cycle_delay ])
          end
        end

        def validate_output_setting( output_setting )
          output_setting.require(:output_index)
          output_setting.require(:function)
          output_setting.require(:cycle_delay)
        end
      end
    end
  end
end

