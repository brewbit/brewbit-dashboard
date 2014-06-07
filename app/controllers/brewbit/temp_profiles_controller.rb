module Brewbit
  class TempProfilesController < ApplicationController
    layout 'brewbit/layouts/temp_profiles'
    before_filter :correct_user, only: [:edit, :update, :destroy]

    # GET /temp_profiles
    def index
      @temp_profiles = brewbit_current_user.temp_profiles.includes( steps: :temp_profile )
    end

    # GET /temp_profiles/new
    def new
      @temp_profile = brewbit_current_user.temp_profiles.build
      
      step_attrs = {
        step_index: 1,
        step_type: TempProfileStep::STEP_TYPE[:hold],
        duration_type: 'days'
      }
      @temp_profile.steps << TempProfileStep.new(step_attrs)
    end

    # GET /temp_profiles/1/edit
    def edit
    end

    # POST /temp_profiles
    def create
      if brewbit_current_user.temperature_scale == 'C'
        params[:temp_profile][:start_value] = TemperatureConverter.celsius_to_fahrenheit params[:temp_profile][:start_value]
        params[:temp_profile][:steps_attributes].each do |id, step_params|
          step_params[:value] = TemperatureConverter.celsius_to_fahrenheit step_params[:value]
        end
      end
      
      @temp_profile = TempProfile.new(temp_profile_params)
      @temp_profile.user = brewbit_current_user

      if @temp_profile.save
        redirect_to temp_profiles_url, notice: 'Temperature profile was successfully created.'
      else
        flash[:error] = @temp_profile.errors.full_messages.to_sentence
        render action: 'new'
      end
    end

    # PATCH/PUT /temp_profiles/1
    def update
      if @temp_profile.update(temp_profile_params)
        redirect_to temp_profiles_url, notice: 'Temperature profile was successfully updated.'
      else
        flash[:error] = @temp_profile.errors.full_messages.to_sentence
        render action: 'edit'
      end
    end

    # DELETE /temp_profiles/1
    def destroy
      temp_profile_references = DeviceSession.where(temp_profile: @temp_profile).count
      if temp_profile_references == 0
        @temp_profile.destroy
        redirect_to temp_profiles_url, notice: 'Temperature profile was successfully destroyed.'
      else
        flash[:error] = 'Temp profile could not be deleted because it is referenced by one or more sessions'
        redirect_to temp_profiles_url
      end
    end

    private
      # Only allow a trusted parameter "white list" through.
      def temp_profile_params
        params.require(:temp_profile).permit(:name, :start_value,
          steps_attributes: [:id, :duration, :duration_type, :step_index, :value, :step_type, :_destroy])
      end

      def correct_user
        @temp_profile = brewbit_current_user.temp_profiles.includes( steps: :temp_profile ).find_by( id: params[:id] )
        redirect_to root_path, error: 'You can only see your temperature profiles' unless @temp_profile
      end
  end
end
