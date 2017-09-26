class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.datetime :start_time
      t.datetime :stop_time
      t.integer :valve_id

      t.timestamps
    end
  end
end
