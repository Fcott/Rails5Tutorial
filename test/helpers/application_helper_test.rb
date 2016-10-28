require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full_title helper' do
    assert_equal full_title, "Rails5Tutorial"
    assert_equal full_title("Help"), "Help | Rails5Tutorial"
  end
end
