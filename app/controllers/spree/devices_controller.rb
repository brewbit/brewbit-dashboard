module Spree
  class DevicesController < Spree::StoreController
    before_filter :correct_user, except: [:index, :activate, :start_activate]
    layout :resolve_layout

    # GET /devices
    def index
      @devices = spree_current_user.devices.includes( [ outputs: [:device], sensors: [:device], commands: [{sensor_settings: [:readings, :sensor, :temp_profile]}] ] )
      @device = @devices.first
    end

    # GET /devices/1
    def show
      @devices = spree_current_user.devices
    end

    # GET /devices/1/edit
    def edit
    end

    # GET /devices/activate
    def start_activate
      render 'activate'
    end

    # POST /devices/activate
    def activate
      begin
        device = Activation.user_activates_device(spree_current_user, params[:activation_token])
      rescue Exception => e
        flash[:notice] = e.message
      else
        redirect_to device, notice: 'Device was successfully activated.'
      end
    end

    # PATCH/PUT /devices/1
    def update
      if @device.update(device_params)
        redirect_to @device, notice: 'Device was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /devices/1
    def destroy
      connection = DeviceConnection.find_by_device_id @device.hardware_identifier
      connection.delete if connection

      @device.destroy

      redirect_to '/dashboard', notice: 'Device was successfully destroyed.'
    end

    private
      # Only allow a trusted parameter "white list" through.
      def device_params
        params.require(:device).permit(:name)
      end

      def correct_user
        @device = spree_current_user.devices.includes(sensors: [:device], commands: [{sensor_settings: [:temp_profile, :sensor, :readings]}]).find( params[:id] )
        redirect_to root_path, error: 'You can only see your own devices' unless @device
      end

      def resolve_layout
        if ( @device == nil ) || ( ['activate', 'start_activate'].include? action_name )
          "spree/layouts/dashboard"
        else
          "spree/layouts/devices"
        end
      end
  end
end
