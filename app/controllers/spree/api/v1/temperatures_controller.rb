class Api::V1::TemperaturesController < ApplicationController
  before_filter :has_correct_authentication_token
  before_filter :check_device_and_probe

  respond_to :json

  def create
    attrs = { probe_id: @probe.id, value: params[:value] }
    @temp = @device.temperatures.create attrs

    logger.debug "Create: #{@temp.inspect}"
    logger.debug "    #{@temp.errors.full_messages}"

    respond_with @temp, location: nil
  end

  private

  def has_correct_authentication_token
    unless @user = ApiKey.find_by_access_token( params[:auth_token] ).try( :user )
      head( :forbidden )
    end
  end

  def check_device_and_probe
    @device = @user.devices.find_by_hardware_identifier params[:device_id]
    return head :unprocessable_entity if @device.blank?

    @probe = @device.probes.find_by_probe_type params[:probe]
    return head :unprocessable_entity if @probe.blank?
  end
end
