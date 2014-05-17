module Spree
  module Api
    module V1
      class FirmwareController < ApiController

        before_filter :validate_check_params!, :only => :check
        before_filter :validate_show_params!, :only => :show

        def check
          if Firmware.is_latest?(@device.update_channel, params[:current_version])
            @update_available = false
          else
            update = Firmware.latest @device.update_channel
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
          if params[:version].blank?
            @message = 'Current version not provided'
            render :error, status: 400
            return
          end
          
          if params[:offset].blank?
            @message = 'Offset not provided'
            render :error, status: 400
            return
          end
          
          if params[:size].blank?
            @message = 'Size not provided'
            render :error, status: 400
            return
          end
          
          if @device.update_channel == 'unstable'
            # on the unstable channel, search for ANY newer version
            @firmware = Firmware.find_by version: params[:version]
          else
            @firmware = Firmware.find_by version: params[:version], channel: 'stable'
          end
          unless @firmware
            @message = 'Firmware version not found'
            render :error, status: 404
            return
          end
          
          @chunk = {
            version: params[:version],
            offset: params[:offset],
            size: params[:size],
            data: @firmware.chunk(params[:offset], params[:size])
          }
        end

      end
    end
  end
end

