require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    skip
    get users_new_url
    assert_response :success
  end

end
