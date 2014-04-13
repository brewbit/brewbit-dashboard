
module Spree
  class DeviceCommandsController < Spree::StoreController
    layout 'spree/layouts/devices'
    before_action :set_device
    before_action :set_device_command, only: [:show, :edit, :destroy]

    # GET /commands
    def index
      @device_commands = @device.commands
    end

    # GET /commands/1
    def show
    end

    # GET /commands/new
    def new
      @device_command = @device.current_command.dup
      @device_command.name = ''
      @device.current_command.sensor_settings.each do |ss|
        @device_command.sensor_settings << ss.dup
      end
      @device.current_command.output_settings.each do |os|
        @device_command.output_settings << os.dup
      end
    end

    # GET /commands/1/edit
    def edit
    end

    # POST /commands
    def create
      begin
        DeviceCommand.transaction do
          @device_command = DeviceCommand.new(device_command_params)
          @device_command.save!

          DeviceService.send_command @device, @device_command
        end
      rescue
        flash[:notice] = 'Command could not be sent to the device.'
        render action: 'new'
      else
        redirect_to @device, notice: 'Device command was successfully sent.'
      end
    end

    # DELETE /commands/1
    def destroy
      @device_command.destroy
      redirect_to device_commands_url, notice: 'Device command was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_device_command
        @device_command = DeviceCommand.find(params[:id])
      end

      def set_device
        @device = Device.find(params[:device_id])
      end

      def notify_device_with_new_settings

      end

      # Only allow a trusted parameter "white list" through.
      def device_command_params
        params.require(:device_command).permit(:name, :device_id,
          output_settings_attributes: [:id, :output_id, :function, :cycle_delay, :sensor_id, :output_mode],
          sensor_settings_attributes: [:id, :sensor_id, :setpoint_type, :static_setpoint, :temp_profile_id] )
      end
  end
end
