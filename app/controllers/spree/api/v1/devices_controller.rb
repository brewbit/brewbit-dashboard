module Spree
  module Api
    module V1
      class DevicesController < ApplicationController
        skip_before_filter  :verify_authenticity_token
  
        before_filter :has_correct_authentication_token
        before_filter :get_device, only: [ :show, :update ]
  
        respond_to :json
  
        class DeviceParams
          def self.build( params )
            params.require( :device ).permit( :name, :user_id,
                                              :hardware_identifier,
                                              :signal_strength, :activation_token )
          end
        end
  
        def update
          params[:device].delete :activation_token
          respond_with @device.update_attributes DeviceParams.build( params )
        end
  
        def show
        end
  
        def index
          @devices = @user.devices
        end
  
        private
  
        def has_correct_authentication_token
          unless @user = ApiKey.find_by_access_token( params[:authentication_token] ).try( :user )
            head( :forbidden )
          end
        end
  
        def get_device
          @device = @user.devices.find_by_hardware_identifier( params[:id] )
          head :forbidden if @device.blank?
        end
      end
    end
  end
end