class AddTempProfileCompletionActionToDeviceSession < ActiveRecord::Migration
  def change
    add_column :device_sessions, :temp_profile_completion_action, :integer
  end
end
