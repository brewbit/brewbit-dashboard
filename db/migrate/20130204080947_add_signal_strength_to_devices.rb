class AddSignalStrengthToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :signal_strength, :decimal
  end
end
