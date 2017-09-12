class CreatePorters < ActiveRecord::Migration[5.1]
  def change
    create_table :porters do |t|
      t.string :host_name
      t.string :port_number

      t.timestamps
    end
  end
end
