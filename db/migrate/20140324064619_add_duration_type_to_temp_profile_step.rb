class AddDurationTypeToTempProfileStep < ActiveRecord::Migration
  def change
    add_column :temp_profile_steps, :duration_type, :string
  end
end
