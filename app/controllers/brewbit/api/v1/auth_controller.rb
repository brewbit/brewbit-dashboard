module Brewbit
  module Api
    module V1
      class AuthController < ApiController
  
        def new
          @device.firmware_version = params[:firmware_version]
          @device.save
        end

      end
    end
  end
end
