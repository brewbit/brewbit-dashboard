module Spree
  module Api
    module V1
      class AuthController < ApplicationController
        respond_to :json
  
        skip_before_filter  :verify_authenticity_token
  
        before_filter :ensure_device_id!, only: :new
        before_filter :ensure_auth_token!, only: :new
  
        def new
          @device = Device.find_by hardware_identifier: params[:device_id]
          if @device
            if @device.user
              if @device.user.authentication_token == params[:auth_token]
                @authorized = true
                @message = 'Auth succeeded'
              else
                @authorized = false
                @message = 'Invalid auth token'
              end
            else
              @authorized = false
              @message = 'Device not activated'
            end
          else
            @authorized = false
            @message = 'Device not found'
          end
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
