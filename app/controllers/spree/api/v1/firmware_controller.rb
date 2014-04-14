module Spree
  module Api
    module V1
      class FirmwareController < ApiController

        before_filter :validate_check_params!, :only => :check
        before_filter :validate_show_params!, :only => :show

        def check
          if Firmware.is_latest? params[:current_version]
            @update_available = false
          else
            update = Firmware.latest
            @update_available = true
            @version = update.version
            @binary_size = update.size
          end
        end
        
        def show
          
        end

        private

        def validate_check_params!
          if params[:current_version].blank?
            @message = 'Current version not provided'
            render :error, status: 400
          end
        end

        def validate_show_params!
        end

      end
    end
  end
end

