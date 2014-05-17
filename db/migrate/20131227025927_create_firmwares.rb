class CreateFirmwares < ActiveRecord::Migration
  def change
    create_table :firmwares do |t|
      t.string :version
      t.integer :size

      t.timestamps
    end
  end
end
