module Spree
  class DeviceCommandsController < Spree::StoreController
    before_action :set_device_command, only: [:show, :edit, :update, :destroy]
  
    # GET /device_commands
    def index
      @device_commands = DeviceCommand.all
    end
  
    # GET /device_commands/1
    def show
    end
  
    # GET /device_commands/new
    def new
      @device_command = DeviceCommand.new
    end
  
    # GET /device_commands/1/edit
    def edit
    end
  
    # POST /device_commands
    def create
      @device_command = DeviceCommand.new(device_command_params)
  
      if @device_command.save
        redirect_to @device_command, notice: 'Device command was successfully created.'
      else
        render action: 'new'
      end
    end
  
    # PATCH/PUT /device_commands/1
    def update
      if @device_command.update(device_command_params)
        redirect_to @device_command, notice: 'Device command was successfully updated.'
      else
        render action: 'edit'
      end
    end
  
    # DELETE /device_commands/1
    def destroy
      @device_command.destroy
      redirect_to device_commands_url, notice: 'Device command was successfully destroyed.'
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_device_command
        @device_command = DeviceCommand.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def device_command_params
        params[:device_command]
      end
  end
end