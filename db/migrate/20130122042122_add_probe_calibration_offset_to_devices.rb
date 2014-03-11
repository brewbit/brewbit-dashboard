class AddProbeCalibrationOffsetToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :probe_calibration_offset, :decimal
  end
end
