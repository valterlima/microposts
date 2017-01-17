require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @user2= users(:archer)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body

    # @user.follow(@user2)
    # @user2.follow(@user)

    # assert @user.following?(@user2)
    # assert_select '#following', @user.following.count
    # assert_select '#followers', @user.followers.count

    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
