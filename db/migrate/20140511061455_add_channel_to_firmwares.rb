class AddChannelToFirmwares < ActiveRecord::Migration
  def change
    add_column :firmwares, :channel, :string
  end
end
