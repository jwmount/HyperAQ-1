require 'test_helper'

class PortersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @porter = porters(:one)
  end

  test "should get index" do
    get porters_url
    assert_response :success
  end

  test "should get new" do
    get new_porter_url
    assert_response :success
  end

  test "should create porter" do
    assert_difference('Porter.count') do
      post porters_url, params: { porter: { host_name: @porter.host_name, port_number: @porter.port_number } }
    end

    assert_redirected_to porter_url(Porter.last)
  end

  test "should show porter" do
    get porter_url(@porter)
    assert_response :success
  end

  test "should get edit" do
    get edit_porter_url(@porter)
    assert_response :success
  end

  test "should update porter" do
    patch porter_url(@porter), params: { porter: { host_name: @porter.host_name, port_number: @porter.port_number } }
    assert_redirected_to porter_url(@porter)
  end

  test "should destroy porter" do
    assert_difference('Porter.count', -1) do
      delete porter_url(@porter)
    end

    assert_redirected_to porters_url
  end
end
