class RemoveBrewDataPoints < ActiveRecord::Migration
  def up
    drop_table :brew_data_points
  end

  def down
    create_table :brew_data_points do |t|
      t.references :brew
      t.references :device

      # Handle range of 999.99 to -999.99 for temperature in Fahrenheart
      t.decimal :temperature, scale: 2, precision: 5

      t.timestamps
    end
    add_index :brew_data_points, :brew_id
    add_index :brew_data_points, :device_id
  end
end
