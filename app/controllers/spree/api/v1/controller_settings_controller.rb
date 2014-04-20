module Spree
  module Api
    module V1
      class ControllerSettingsController < ApiController
        respond_to :json

        before_filter :validate_params!

        def create
          params[:name] = "Device-Initiated Session"

          session = ControllerSettingsService.create( @device, params )

          if session.save
            @message = 'success'
          else
            @message = "Could not save session: #{session.errors.full_messages}"
            render :error, status: 400
          end
        end

        private

        def validate_params!
          [:sensor_index, :setpoint_type].each do |param|
            if params[param].blank?
              @message = "#{param.to_s.capitalize} not provided"
              render :error, status: 400
              return
            end
          end

          if DeviceSession::SETPOINT_TYPE[:static] == params[:setpoint_type]
            if params[:static_setpoint].blank?
              @message = 'Static setpoint not provided'
              render :error, status: 400
              return
            end
          else
            if params[:temp_profile_id].blank?
              @message = 'Temp Profile ID not provided'
              render :error, status: 400
              return
            end
          end

          params[:output_settings].each do |output_setting|
            validate_output_setting( output_setting )
          end
        end

        def validate_output_setting( output_setting )
          if output_setting[:index].blank?
            @message = 'Output settings index not provided'
            render :error, status: 400
            return
          elsif output_setting[:function].blank?
            @message = 'Output settings function not provided'
            render :error, status: 400
            return
          elsif output_setting[:cycle_delay].blank?
            @message = 'Output settings cycle_delay not provided'
            render :error, status: 400
            return
          end
        end
      end
    end
  end
end

