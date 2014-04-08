module Spree
  module Api
    module V1
      class DeviceReportController < ApplicationController
        respond_to :json
  
        skip_before_filter  :verify_authenticity_token
  
        before_filter :ensure_device_id!, only: :new
        before_filter :ensure_auth_token!, only: :new
  
        def new
          @device = Device.find params[:device_id]
          # TODO verify auth
          attrs = {
            device: @device,
            value: params[:value],
            setpoint: params[:setpoint]
          }
          @device.readings.create! attrs
        end
  
        private
  
        def ensure_device_id!
          if params[:device_id].blank?
            @authorized = false
            @message = 'No device id provided'
            render :new, status: 404
          end
        end
        
        def ensure_auth_token!
          if params[:auth_token].blank?
            @authorized = false
            @message = 'No auth token provided'
            render :new, status: 404
          end
        end
  
      end
    end
  end
end
