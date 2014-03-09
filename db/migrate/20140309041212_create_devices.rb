class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.integer :user_id
      t.string :hardware_id
      t.string :activation_token

      t.timestamps
    end
  end
end
