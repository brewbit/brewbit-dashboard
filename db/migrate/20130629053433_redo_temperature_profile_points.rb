class RedoTemperatureProfilePoints < ActiveRecord::Migration
  def up
    drop_table :temperature_profile_points

    create_table :temperature_profile_points do |t|
      t.integer :time_offset
      t.integer :point_index
      t.decimal :temperature
      t.string :transition_type
      t.integer :temperature_profile_id

      t.timestamps
    end
  end

  def down
    drop_table :temperature_profile_points

    create_table :temperature_profile_points do |t|
      t.decimal :start_minute
      t.decimal :start_hour
      t.decimal :start_day
      t.integer :temperature_profile_point_id
      t.decimal :temperature
      t.string :temperature_scale
      t.string :transition_type

      t.timestamps
    end
  end
end
