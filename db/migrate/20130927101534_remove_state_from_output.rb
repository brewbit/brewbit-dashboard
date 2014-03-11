class RemoveStateFromOutput < ActiveRecord::Migration
  def up
    remove_column :outputs, :state
  end

  def down
    add_column :outputs, :state, :string
  end
end
