require 'test_helper'

class ValvesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valve = valves(:one)
  end

  test "should get index" do
    get valves_url
    assert_response :success
  end

  test "should get new" do
    get new_valve_url
    assert_response :success
  end

  test "should create valve" do
    assert_difference('Valve.count') do
      post valves_url, params: { valve: { active_history_id: @valve.active_history_id, active_sprinkle_id: @valve.active_sprinkle_id, base_time: @valve.base_time, bb2relay_color: @valve.bb2relay_color, bb_pin: @valve.bb_pin, cmd: @valve.cmd, cpu2bb_color: @valve.cpu2bb_color, gpio_pin: @valve.gpio_pin, name: @valve.name, relay2valve_color: @valve.relay2valve_color, relay_index: @valve.relay_index, relay_module: @valve.relay_module } }
    end

    assert_redirected_to valve_url(Valve.last)
  end

  test "should show valve" do
    get valve_url(@valve)
    assert_response :success
  end

  test "should get edit" do
    get edit_valve_url(@valve)
    assert_response :success
  end

  test "should update valve" do
    patch valve_url(@valve), params: { valve: { active_history_id: @valve.active_history_id, active_sprinkle_id: @valve.active_sprinkle_id, base_time: @valve.base_time, bb2relay_color: @valve.bb2relay_color, bb_pin: @valve.bb_pin, cmd: @valve.cmd, cpu2bb_color: @valve.cpu2bb_color, gpio_pin: @valve.gpio_pin, name: @valve.name, relay2valve_color: @valve.relay2valve_color, relay_index: @valve.relay_index, relay_module: @valve.relay_module } }
    assert_redirected_to valve_url(@valve)
  end

  test "should destroy valve" do
    assert_difference('Valve.count', -1) do
      delete valve_url(@valve)
    end

    assert_redirected_to valves_url
  end
end
