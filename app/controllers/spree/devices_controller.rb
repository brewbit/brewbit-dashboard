module Spree
  class DevicesController < Spree::StoreController
    before_filter :check_authorization
    before_action :set_device, only: [:show, :edit, :update, :destroy]
  
    # GET /devices
    def index
      @devices = Device.all
    end
  
    # GET /devices/1
    def show
    end
  
    # GET /devices/new
    def new
      @device = Device.new
    end
  
    # GET /devices/1/edit
    def edit
    end
  
    # POST /devices
    def create
      @device = Device.new(device_params)
  
      if @device.save
        redirect_to @device, notice: 'Device was successfully created.'
      else
        render action: 'new'
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
      @device.destroy
      redirect_to devices_url, notice: 'Device was successfully destroyed.'
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_device
        @device = Device.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def device_params
        params.require(:device).permit(:name, :user_id, :hardware_id, :activation_token)
      end
  end
end
