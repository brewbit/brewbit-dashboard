module Spree
  module Admin
    class FirmwareController < Spree::Admin::BaseController

      class FirmwareParams
        def self.build( params )
          params.require( :firmware ).permit( :version, :file )
        end
      end

      def index
        @firmware_list = Spree::Firmware.order( 'version DESC' )
      end

      def new
        @firmware = Spree::Firmware.new
      end

      def create
        if params[:firmware][:file]
          file = params[:firmware][:file]
          params[:firmware].delete :file
        end

        @firmware = Spree::Firmware.new( FirmwareParams.build(params) ) do |t|
          t.file = file.read if file
        end

        if @firmware.save
          redirect_to admin_firmware_index_path
        else
          render action: :new
        end
      end

      def destroy
        @firmware = Spree::Firmware.find params[:id]
        @firmware.destroy
        redirect_to admin_firmware_index_path
      end

      def serve
        @firmware = Spree::Firmware.find params[:id]
        send_data @firmware.file, type: 'application/octet-stream', filename: file_name, disposition: 'inline'
      end

      private

      def file_name
        "app_mt_update-#{@firmware.version}.bin"
      end
    end
  end
end
