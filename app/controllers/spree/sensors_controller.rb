module Spree
  class SensorsController < Spree::StoreController
    load_and_authorize_resource :device
    load_and_authorize_resource :sensor, :through => :device
  
    # GET /devices/1/sensors/1
    def show
    end
  
    # GET /devices/1/sensors/1/edit
    def edit
    end
    
    # PATCH/PUT /devices/1/sensors/1
    def update
      if @sensor.update(sensor_params)
        redirect_to spree_brewbit_dashboard_path, notice: 'Sensor was successfully updated.'
      else
        render action: 'edit'
      end
    end
  
    private
      # Only allow a trusted parameter "white list" through.
      def sensor_params
        params.require(:sensor).permit(:setpoint_type, :static_setpoint, :dynamic_setpoint)
      end
  end
end
