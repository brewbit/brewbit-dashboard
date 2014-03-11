class CreateProbes < ActiveRecord::Migration
  def change
    create_table :probes do |t|
      t.references :device
      t.decimal :last_temperature

      t.timestamps
    end

    add_index :probes, :device_id
  end
end
