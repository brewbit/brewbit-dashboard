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
