module Spree
  class DynamicSetpointsController < Spree::StoreController
    before_filter :correct_user, only: [:edit, :update, :destroy]

    # GET /dynamic_setpoints
    def index
      @dynamic_setpoints = spree_current_user.dynamic_setpoints
    end

    # GET /dynamic_setpoints/new
    def new
      @dynamic_setpoint = spree_current_user.dynamic_setpoints.build
    end

    # GET /dynamic_setpoints/1/edit
    def edit
    end

    # POST /dynamic_setpoints
    def create
      @dynamic_setpoint = DynamicSetpoint.new(dynamic_setpoint_params)
      @dynamic_setpoint.user = spree_current_user

      if @dynamic_setpoint.save
        redirect_to @dynamic_setpoint, notice: 'Temperature profile was successfully created.'
      else
        flash[:error] = @dynamic_setpoint.errors.full_messages.to_sentence
        render action: 'new'
      end
    end

    # PATCH/PUT /dynamic_setpoints/1
    def update
      if @dynamic_setpoint.update(dynamic_setpoint_params)
        redirect_to edit_dynamic_setpoint_path(@dynamic_setpoint), notice: 'Temperature profile was successfully updated.'
      else
        flash[:error] = @dynamic_setpoint.errors.full_messages.to_sentence
        render action: 'edit'
      end
    end

    # DELETE /dynamic_setpoints/1
    def destroy
      @dynamic_setpoint.destroy
      redirect_to dynamic_setpoints_url, notice: 'Temperature profile was successfully destroyed.'
    end

    private
      # Only allow a trusted parameter "white list" through.
      def dynamic_setpoint_params
        params.require(:dynamic_setpoint).permit(:name, steps_attributes: [:id, :duration, :step_index, :value, :step_type, :_destroy])
      end

      def correct_user
        @dynamic_setpoint = spree_current_user.dynamic_setpoints.find_by( id: params[:id] )
        redirect_to root_path, error: 'You can only see your temperature profiles' unless @dynamic_setpoint
      end
  end
end
