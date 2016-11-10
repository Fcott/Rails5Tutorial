require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "sign up with invalid information" do
    get signup_path
    assert_no_difference 'User.count' do
      assert_select '[action="/signup"]'
      post signup_path, params: { user: {
                        name:  "  ",
                        email: "user@invalid",
                        password:              "foo",
                        password_confirmation: "bar"
        }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "sign up with valid information" do
    get signup_path
    assert_difference 'User.count', 1 do
      assert_select '[action="/signup"]'
      post signup_path, params: { user: {
                          name: 'mike',
                          email: 'mike@valid.com',
                          password: 'validvalid',
                          password_confirmation: 'validvalid'
        }}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'
    assert_not flash.empty?
    assert is_logged_in?
  end

end
