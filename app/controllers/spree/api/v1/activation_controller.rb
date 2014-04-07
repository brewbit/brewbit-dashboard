module Spree
  module Api
    module V1
      class ActivationController < ApplicationController
        respond_to :json
  
        skip_before_filter  :verify_authenticity_token
  
        before_filter :ensure_device_id!, only: :new
        before_filter :ensure_token!, only: :create
        before_filter :ensure_device_exists_with_device_id!, only: :create
        before_filter :ensure_user!, only: :create
  
        def new
          @device = Activation.start( params[:device_id] )
          @device.save
        end
  
        def create
          @auth_token = Activation.finish! @device
  
          if @auth_token
            render :create, status: 200
          else
            render :create, status: 404
          end
        end
  
        private
  
        def ensure_device_id!
          if params[:device_id].blank?
            @token = nil
            render :new, status: 404
          end
        end
  
        def ensure_token!
          @device = Device.find_by_activation_token params[:activation_token]
  
          unless @device
            @auth_token = nil
            render :create, status: 404
          end
        end
  
        def ensure_device_exists_with_device_id!
          unless @device.hardware_identifier == params[:device_id]
            @auth_token = nil
            render :create, status: 404
          end
        end
  
        def ensure_user!
          unless @device.user
            @auth_token = nil
            render :create, status: 404
          end
        end
      end
    end
  end
end
