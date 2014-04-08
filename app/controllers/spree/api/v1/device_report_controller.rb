module Spree
  module Api
    module V1
      class DeviceReportController < ApiController
        
        before_filter :validate_params!
  
        def create
          SensorReadingsService.record( @device, params[:sensor_index], params[:reading], params[:setpoint] )
        end
        
        private
        
        def validate_params!
          if params[:sensor_index].blank?
            @message = 'Sensor index not provided'
            render :error, status: 400
          elsif params[:reading].blank?
            @message = 'Reading not provided'
            render :error, status: 400
          elsif params[:setpoint].blank?
            @message = 'Setpoint not provided'
            render :error, status: 400
          end
        end
  
      end
    end
  end
end
