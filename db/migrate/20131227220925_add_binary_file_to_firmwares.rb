class AddBinaryFileToFirmwares < ActiveRecord::Migration
  def change
    add_column :firmwares, :file, :binary
  end
end
