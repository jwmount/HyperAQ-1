class CreateValves < ActiveRecord::Migration[5.1]
  def change
    create_table :valves do |t|
      t.string :name
      t.integer :gpio_pin
      t.integer :active_history_id
      t.integer :cmd

      t.timestamps
    end
  end
end
