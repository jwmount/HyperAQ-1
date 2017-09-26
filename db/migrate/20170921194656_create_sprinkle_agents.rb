class CreateSprinkleAgents < ActiveRecord::Migration[5.1]
  def change
    create_table :sprinkle_agents do |t|
      t.integer :sprinkle_id

      t.timestamps
    end
  end
end
