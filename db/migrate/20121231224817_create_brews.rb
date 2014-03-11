class CreateBrews < ActiveRecord::Migration
  def change
    create_table :brews do |t|
      t.string :name
      t.date :date_started
      t.date :date_ended
      t.references :user

      t.timestamps
    end
  end
end
