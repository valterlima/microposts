require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  # test "the truth" do
  #   assert true
  # end
  def setup
    @michael = users(:michael)
    @archer= users(:archer)
  end

  test "profile display" do
    get user_path(@michael)
    assert_template 'users/show'
    assert_select 'title', full_title(@michael.name)
    assert_select 'h1', text: @michael.name
    assert_select 'h1>img.gravatar'
    assert_match @michael.microposts.count.to_s, response.body

    assert @archer.following?(@michael)
    assert_select '#following', "#{@michael.following.count}"
    assert_select '#followers', "#{@michael.followers.count}"

    assert_select 'div.pagination', count: 1
    @michael.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
