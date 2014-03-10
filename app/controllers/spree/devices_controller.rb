module Spree
  class DevicesController < Spree::StoreController
    load_and_authorize_resource :except => 'activate'
  
    # GET /devices
    def index
    end
  
    # GET /devices/1
    def show
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
    
    # GET /devices/activate
    def start_activate
      render 'activate'
    end
  
    # POST /devices/activate
    def activate
      @device = Device.find_by activation_token: params[:activation_token]
      if !@device
        flash[:notice] = 'A device with that activation token could not be found.'
      elsif @device.user
        flash[:notice] = 'That device is already activated.'
      else
        @device.user = spree_current_user
        if @device.save
          redirect_to @device, notice: 'Device was successfully activated.'
        else
          flash[:notice] = 'Something went wrong...'
        end
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
      # Only allow a trusted parameter "white list" through.
      def device_params
        params.require(:device).permit(:name)
      end
  end
end
