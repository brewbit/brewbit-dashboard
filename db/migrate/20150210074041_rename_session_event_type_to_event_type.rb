class RenameSessionEventTypeToEventType < ActiveRecord::Migration
  def change
    rename_column :session_events, :type, :event_type
  end
end
