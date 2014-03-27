require 'protobuf_messages/messages'

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
      @device_command = Defaults.build_device_command @device, false
    end

    # GET /commands/1/edit
    def edit
    end

    # POST /commands
    def create
      @device_command = DeviceCommand.new(device_command_params)

      if @device_command.save
        notify_device_with_new_settings
        redirect_to @device, notice: 'Device command was successfully sent.'
      else
        render action: 'new'
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
        connection = DeviceConnection.find_by_device_id( @device.hardware_identifier )

        # no need to send settings to a device that's not connected
        unless connection
          logger.warn "Device not connected during settings update #{@device.hardware_identifier}"
          logger.warn "Connected devices are: #{DeviceConnection.all.inspect}"
          return
        end

        data = {
          outputs: [],
          sensors: [],
          temp_profiles: []
        }
        @device_command.output_settings.each do |o|
          output = {
            index:            o.output.output_index,
            function:         o.function,
            cycle_delay:      o.cycle_delay,
            sensor_index:     o.sensor.sensor_index,
            output_mode:      o.output_mode
          }
          data[:outputs] << output
        end
        @device_command.sensor_settings.each do |s|
          sensor = {
            index:            s.sensor.sensor_index,
            setpoint_type:    s.setpoint_type
          }
          case s.setpoint_type
          when Sensor::SETPOINT_TYPE[:static]
            sensor[:static_setpoint] = s.static_setpoint
          when Sensor::SETPOINT_TYPE[:temp_profile]
            sensor[:temp_profile_id] = s.temp_profile_id
            temp_profile = {
              id:           s.temp_profile.id,
              name:         s.temp_profile.name,
              start_value:  s.temp_profile.start_value,
              steps:        s.temp_profile.steps.collect { |step| {
                  duration: step.duration_for_device,
                  value:    step.value,
                  type:     step.step_type
                }
              }
            }
            data[:temp_profiles] << temp_profile
          end
          data[:sensors] << sensor
        end

        type = ProtobufMessages::ApiMessage::Type::DEVICE_SETTINGS_NOTIFICATION
        message = ProtobufMessages::Builder.build( type, data )
        logger.debug "Sending Device Settings Notification Message: #{message.inspect}"
        ProtobufMessages::Sender.send( message, connection )
      end

      # Only allow a trusted parameter "white list" through.
      def device_command_params
        params.require(:device_command).permit(:name,
          output_settings_attributes: [:id, :output_id, :function, :cycle_delay, :sensor_id, :output_mode],
          sensor_settings_attributes: [:id, :sensor_id, :setpoint_type, :static_setpoint, :temp_profile_id] )
      end
  end
end
