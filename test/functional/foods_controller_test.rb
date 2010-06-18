require 'test_helper'

class FoodsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:foods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should create food" do
  #   assert_difference('Food.count') do
  #     post :create, :food => { }
  #   end
  # 
  #   assert_redirected_to food_path(assigns(:food))
  # end

  test "should show food" do
    get :show, :id => foods(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => foods(:one).id
    assert_response :success
  end

  # test "should update food" do
  #   put :update, :id => foods(:one).id, :food => { }
  #   assert_redirected_to food_path(assigns(:food))
  # end

  test "should destroy food" do
    assert_difference('Food.count', -1) do
      delete :destroy, :id => foods(:one).id
    end

    assert_redirected_to foods_path
  end
end
