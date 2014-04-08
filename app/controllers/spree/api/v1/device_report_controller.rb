module Spree
  module Api
    module V1
      class DeviceReportController < ApiController
        
        before_filter :validate_params!
  
        def create
          params[:controller_reports].each do |report|
            SensorReadingsService.record( @device, report[:controller_index], report[:sensor_reading], report[:setpoint] )
          end
        end
        
        private
        
        def validate_params!
          params[:controller_reports].each do |report|
            if report[:controller_index].blank?
              @message = 'Controller index not provided'
              render :error, status: 400
              return
            elsif report[:sensor_reading].blank?
              @message = 'Sensor reading not provided'
              render :error, status: 400
              return
            elsif report[:setpoint].blank?
              @message = 'Setpoint not provided'
              render :error, status: 400
              return
            end
          end
        end
  
      end
    end
  end
end
