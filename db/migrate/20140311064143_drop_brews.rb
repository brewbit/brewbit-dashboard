class DropBrews < ActiveRecord::Migration
  def change
    
    drop_table :brews
  end
end
