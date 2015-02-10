class AddSessionEventsTable < ActiveRecord::Migration
  def change
    create_table :session_events do |t|
      t.integer  'device_session_id'
      t.string   'type'
      t.json     'event_data'
      t.datetime 'created_at'
    end
  end
end
