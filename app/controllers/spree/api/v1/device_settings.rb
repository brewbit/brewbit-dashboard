module Spree
  module Api
    module V1
      class DeviceSettingsController < ApiController

        before_filter :validate_params!

        def create
          DeviceSettingsService.update( @device, params )
        end

        private

        def validate_params!
          params[:outputs].each do |output|
            validate_output( output )
          end

          params[:sensors].each do |sensor|
            validate_sensor( sensor )
          end
        end

        def validate_output( output )
          if output[:id].blank?
            @message = 'Output ID not provided'
            render :error, status: 400
            return
          elsif output[:function].blank?
            @message = 'Output Function not provided'
            render :error, status: 400
            return
          elsif output[:mode].blank?
            @message = 'Output mode not provided'
            render :error, status: 400
            return
          elsif output[:cycle_delay].blank?
            @message = 'Output cycle_delay not provided'
            render :error, status: 400
            return
          elsif output[:sensor].blank?
            @message = 'Output sensor not provided'
            render :error, status: 400
            return
          end
        end

        def validate_sensor( sensor )
          if sensor[:id].blank?
            @message = 'Sensor id not provided'
            render :error, status: 400
            return
          elsif sensor[:setpoint_type].blank?
            @message = 'Sensor setpoint_type not provided'
            render :error, status: 400
            return
          elsif sensor[:static_setpoint].blank?
            @message = 'Sensor static_setpoint not provided'
            render :error, status: 400
            return
          elsif sensor[:temp_profile_id].blank?
            @message = 'Sensor temp_profile_id not provided'
            render :error, status: 400
            return
          end
        end
      end
    end
  end
end

