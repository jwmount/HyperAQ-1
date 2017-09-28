class CreateMinuteHands < ActiveRecord::Migration[5.1]
  def change
    create_table :minute_hands do |t|
      t.string :state

      t.timestamps
    end
  end
end
