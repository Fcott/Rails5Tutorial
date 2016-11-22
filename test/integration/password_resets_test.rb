require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password_reset" do
    get new_password_reset_path
    #invelid emial
    post password_resets_path, params: { password_reset: { email: ''}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #valid email
    post password_resets_path, params: { password_reset: { email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    #Password reset form
    user = assigns(:user)
    #invalid email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    #Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #invalid reset_token
    get edit_password_reset_path('', email: user.email)
    assert_redirected_to root_url
    #valid user
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    #invalid password & Confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email,
                        user: { password: 'foofoo', password_confirmation: 'foofff'}}
    assert_select 'div#error_explanation'
    #empty password & Confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email,
                        user: { password: '', password_confirmation: ''}}
    assert_select 'div#error_explanation'
    #valid password & Confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email,
                        user: { password: 'resetpw', password_confirmation: 'resetpw'}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_nil user.reload.reset_digest
    assert_redirected_to user
  end

  test "password reset has expired" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email}}
    user = assigns(:user)
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token), params: { email: user.email,
                        user: { password: 'resetpw', password_confirmation: 'resetpw'}}
    assert_response :redirect
    follow_redirect!
    assert_match /\w*expired/i, response.body
  end
end
