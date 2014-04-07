class Api::V1::TemperatureProfilesController < ApplicationController

  before_filter :has_correct_authentication_token
  before_filter :get_temperature_profile, only: [ :show ]

  respond_to :json

  def show
  end

  def index
    @temperature_profiles = @user.temperature_profiles
  end

  def has_correct_authentication_token
    unless @user = ApiKey.find_by_access_token( params[:auth_token] ).try( :user )
      head( :forbidden )
    end
  end

  def get_temperature_profile
    @temperature_profile = @user.temperature_profiles.find_by_id params[:id]
    head :forbidden if @temperature_profile.blank?
  end
end

