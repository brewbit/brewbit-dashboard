class AddCompressorDelayToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :compressor_delay, :integer
  end
end
