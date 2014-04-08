module Spree
  module Api
    module V1
      class ApiController < ApplicationController
        respond_to :json
  
        skip_before_filter :verify_authenticity_token
  
        before_filter :ensure_device_id!
        before_filter :ensure_auth_token!
        before_filter :api_authorize!
        
        private
        
        def api_authorize!
          @device = Device.find_by hardware_identifier: params[:device_id]
          if @device
            if @device.user
              if @device.user.authentication_token == params[:auth_token]
                @authorized = true
                @message = 'Auth succeeded'
                status = 200
              else
                @authorized = false
                @message = 'Invalid auth token'
                status = 401
              end
            else
              @authorized = false
              @message = 'Device not activated'
              status = 401
            end
          else
            @authorized = false
            @message = 'Device not found'
            status = 404
          end
          render :new, status: status
        end
        
        def ensure_device_id!
          if params[:device_id].blank?
            @authorized = false
            @message = 'No device id provided'
            render :new, status: 400
          end
        end
        
        def ensure_auth_token!
          if params[:auth_token].blank?
            @authorized = false
            @message = 'No auth token provided'
            render :new, status: 400
          end
        end
      end
    end
  end
end
