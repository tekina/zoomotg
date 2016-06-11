require 'test_helper'

class ZoomcarControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
