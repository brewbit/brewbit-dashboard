module Api
  module V1
    class AccountController < ApplicationController
      before_filter :has_correct_authentication_token, only: [ :show, :authenticate ]
      before_filter :get_device, only: :authenticate

      respond_to :json

      def token
        @user = User.find_by_email( params[:username].downcase )

        if @user.nil? || !@user.valid_password?( params[:password] )
          respond_with 'Invalid email or password', status: :unauthorized, location: nil
        else
          respond_with token: @user.authentication_token
        end
      end

      def show
        respond_with @user
      end

      def authenticate
        respond_with '', location: nil, status: 200
      end

      private

      def get_device
        @device = @user.devices.find_by_hardware_identifier params[:device_id]

        respond_with 'Login Failed! Please check the data provided', location: nil, status: 401 unless @device
      end

      def has_correct_authentication_token
        @user = ApiKey.find_by_access_token( params[:authentication_token] ).try( :user )

        respond_with 'Bad request! Please check your data', location: nil, status: 401 unless @user
      end
    end
  end
end
