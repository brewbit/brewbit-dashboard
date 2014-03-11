class AddHardwareIdentifierToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :hardware_identifier, :string
    add_index :devices, :hardware_identifier
  end
end
