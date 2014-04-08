module Spree
  module Api
    module V1
      class ApiController < ApplicationController
        respond_to :json
  
        skip_before_filter :verify_authenticity_token
  
        before_filter :ensure_device_id!
        before_filter :ensure_auth_token!
        before_filter :ensure_device_exists!
        before_filter :ensure_device_activated!
        before_filter :ensure_auth_token_matches!
        
        private
        
        def ensure_auth_token_matches!
          unless @device.user.authentication_token == params[:auth_token]
            @message = 'Invalid auth token'
            render :error, status: 401
          end
        end
        
        def ensure_device_activated!
          unless @device.user
            @message = 'Device not activated'
            render :error, status: 401            
          end
        end
        
        def ensure_device_exists!
          @device = Device.find_by hardware_identifier: params[:device_id]
          unless @device
            @message = 'Device not found'
            render :error, status: 404
          end
        end
        
        def ensure_device_id!
          if params[:device_id].blank?
            @message = 'No device id provided'
            render :error, status: 400
          end
        end
        
        def ensure_auth_token!
          if params[:auth_token].blank?
            @message = 'No auth token provided'
            render :error, status: 400
          end
        end
      end
    end
  end
end
