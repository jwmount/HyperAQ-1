class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.datetime :start_time
      t.string :start_time_display
      t.string :stop_time_display
      t.integer :valve_id

      t.timestamps
    end
  end
end
