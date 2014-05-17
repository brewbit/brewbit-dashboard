class RenameCompressorDelayToCycleDelay < ActiveRecord::Migration
  def up
    rename_column :outputs, :compressor_delay, :cycle_delay
  end

  def down
    rename_column :outputs, :cycle_delay, :compressor_delay
  end
end
