class MoveControlModeToDevice < ActiveRecord::Migration
  def change
    remove_column :output_settings, :output_mode, :integer
    add_column :devices, :control_mode, :integer
  end
end
