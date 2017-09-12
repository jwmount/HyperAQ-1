class CreateValves < ActiveRecord::Migration[5.1]
  def change
    create_table :valves do |t|
      t.string :name
      t.integer :gpio_pin
      t.integer :active_sprinkle_id
      t.integer :active_history_id
      t.string :cpu2bb_color
      t.integer :bb_pin
      t.string :bb2relay_color
      t.integer :relay_module
      t.integer :relay_index
      t.string :relay2valve_color
      t.integer :cmd

      t.timestamps
    end
  end
end
