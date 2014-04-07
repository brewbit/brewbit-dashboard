module Api
  module V1
    class BrewsController < ApplicationController
      before_filter :has_correct_authentication_token
      before_filter :get_brew, only: [ :show, :update ]

      respond_to :json

      class BrewParams
        def self.build( params )
          params.require( :brew ).permit( :date_ended, :name, :date_started,
                                          :device_id, :temperature_profile_id,
                                          :probe_id )
        end
      end

      def index
        @brews = @user.brews
      end

      def show
      end

      def update
        respond_with @brew.update_attributes BrewParams.build( params )
      end

      private

      def has_correct_authentication_token
        unless @user = ApiKey.find_by_access_token( params[:auth_token]).try( :user )
          head :forbidden
        end
      end

      def get_brew
        @brew = @user.brews.find_by_id( params[:id] )
        head :forbidden if @brew.blank?
      end
    end
  end
end
