class AddOccurredAtToSessionEvents < ActiveRecord::Migration
  def up
    add_column :session_events, :occurred_at, :datetime
    
    SessionEvent.all.each do |event|
      event.occurred_at = event.created_at
      event.save
    end
  end
  
  def down
    remove_column :session_events, :occurred_at
  end
end
