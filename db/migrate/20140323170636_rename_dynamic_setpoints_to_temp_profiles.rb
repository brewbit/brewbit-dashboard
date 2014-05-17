class RenameDynamicSetpointsToTempProfiles < ActiveRecord::Migration
  def up
    rename_column :sensors, :dynamic_setpoint_id, :temp_profile_id
    rename_column :dynamic_setpoint_steps, :dynamic_setpoint_id, :temp_profile_id
    rename_table :dynamic_setpoint_steps, :temp_profile_steps
    rename_table :dynamic_setpoints, :temp_profiles
  end

  def down
    rename_column :sensors, :temp_profile_id, :dynamic_setpoint_id
    rename_column :temp_profile_steps, :temp_profile_id, :dynamic_setpoint_id
    rename_table :temp_profile_steps, :dynamic_setpoint_steps
    rename_table :temp_profiles, :dynamic_setpoints
  end
end
