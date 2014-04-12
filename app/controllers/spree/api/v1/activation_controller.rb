module Spree
  module Api
    module V1
      class ActivationController < ApplicationController
        respond_to :json
  
        skip_before_filter  :verify_authenticity_token
  
        before_filter :ensure_device_id!, only: :new
  
        def new
          @device = Activation.start( params[:device_id] )
          @device.save
        end
  
        private
  
        def ensure_device_id!
          if params[:device_id].blank?
            @token = nil
            render :new, status: 404
          end
        end
  
      end
    end
  end
end
