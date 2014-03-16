module Spree
  class DynamicSetpointsController < Spree::StoreController
    load_and_authorize_resource :except => 'create'
  
    # GET /dynamic_setpoints
    def index
    end
  
    # GET /dynamic_setpoints/1
    def show
    end
  
    # GET /dynamic_setpoints/new
    def new
    end
  
    # GET /dynamic_setpoints/1/edit
    def edit
    end
  
    # POST /dynamic_setpoints
    def create
      @dynamic_setpoint = DynamicSetpoint.new(dynamic_setpoint_params)
      @dynamic_setpoint.user = spree_current_user
  
      if @dynamic_setpoint.save
        redirect_to @dynamic_setpoint, notice: 'Dynamic setpoint was successfully created.'
      else
        render action: 'new'
      end
    end
  
    # PATCH/PUT /dynamic_setpoints/1
    def update
      if @dynamic_setpoint.update(dynamic_setpoint_params)
        redirect_to @dynamic_setpoint, notice: 'Dynamic setpoint was successfully updated.'
      else
        render action: 'edit'
      end
    end
  
    # DELETE /dynamic_setpoints/1
    def destroy
      @dynamic_setpoint.destroy
      redirect_to dynamic_setpoints_url, notice: 'Dynamic setpoint was successfully destroyed.'
    end
  
    private
      # Only allow a trusted parameter "white list" through.
      def dynamic_setpoint_params
        params.require(:dynamic_setpoint).permit(:name)
      end
  end
end
