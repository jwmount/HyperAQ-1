json.extract! valve, :id, :name, :gpio_pin, :active_sprinkle_id, :active_history_id, :cpu2bb_color, :bb_pin, :bb2relay_color, :relay_module, :relay_index, :relay2valve_color, :cmd, :created_at, :updated_at
json.url valve_url(valve, format: :json)
