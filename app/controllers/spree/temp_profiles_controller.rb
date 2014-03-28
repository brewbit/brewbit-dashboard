module Spree
  class TempProfilesController < Spree::StoreController
    before_filter :correct_user, only: [:edit, :update, :destroy]

    # GET /temp_profiles
    def index
      @temp_profiles = spree_current_user.temp_profiles
    end

    # GET /temp_profiles/new
    def new
      @temp_profile = spree_current_user.temp_profiles.build
    end

    # GET /temp_profiles/1/edit
    def edit
    end

    # POST /temp_profiles
    def create
      @temp_profile = TempProfile.new(temp_profile_params)
      @temp_profile.user = spree_current_user

      if @temp_profile.save
        redirect_to spree_brewbit_dashboard_path, notice: 'Temperature profile was successfully created.'
      else
        flash[:error] = @temp_profile.errors.full_messages.to_sentence
        render action: 'new'
      end
    end

    # PATCH/PUT /temp_profiles/1
    def update
      if @temp_profile.update(temp_profile_params)
        redirect_to edit_temp_profile_path(@temp_profile), notice: 'Temperature profile was successfully updated.'
      else
        flash[:error] = @temp_profile.errors.full_messages.to_sentence
        render action: 'edit'
      end
    end

    # DELETE /temp_profiles/1
    def destroy
      @temp_profile.destroy
      redirect_to temp_profiles_url, notice: 'Temperature profile was successfully destroyed.'
    end

    private
      # Only allow a trusted parameter "white list" through.
      def temp_profile_params
        params.require(:temp_profile).permit(:name, :start_value, steps_attributes: [:id, :duration, :duration_type, :step_index, :value, :step_type, :_destroy])
      end

      def correct_user
        @temp_profile = spree_current_user.temp_profiles.find_by( id: params[:id] )
        redirect_to root_path, error: 'You can only see your temperature profiles' unless @temp_profile
      end
  end
end
