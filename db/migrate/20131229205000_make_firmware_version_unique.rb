class MakeFirmwareVersionUnique < ActiveRecord::Migration
  def up
    add_index :firmwares, :version, unique: true
  end

  def down
    remove_index :firmwares, :version
  end
end
