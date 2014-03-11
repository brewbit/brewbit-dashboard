class RemoveProbeOffsetFromDevice < ActiveRecord::Migration
  def up
    remove_column :devices, :probe_calibration_offset
  end

  def down
    add_column :devices, :probe_calibration_offset, :decimal
  end
end
