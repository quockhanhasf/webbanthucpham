require "test_helper"

class ThongkeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get thongke_index_url
    assert_response :success
  end
end
