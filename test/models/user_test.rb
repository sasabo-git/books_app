# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @carol = users(:carol)

    @github_username = "mockuser"
    @github_email = "mock@example.com"
    OmniAuth.config.test_mode = true
    @github_authentication = OmniAuth::AuthHash.new({
      provider: "github",
      uid: "1234",
      info: {
        name: @github_username,
        email: @github_email,
        image: "https://placehold.jp/150x150.png"
      }
    })
  end

  test "should find by username or email" do
    assert_equal(@alice, User.find_first_by_auth_conditions({ login: @alice.username }))
    assert_equal(@alice, User.find_first_by_auth_conditions({ login: @alice.email }))
  end

  test "should follow and unfollow a user" do
    assert_not_includes @alice.following, @carol
    assert_not_includes @carol.followers, @alice
    assert_not @alice.following?(@carol)

    @alice.follow(@carol)
    assert_includes @alice.following, @carol
    assert_includes @carol.followers, @alice
    assert @alice.following?(@carol)

    @alice.unfollow(@carol)
    assert_not_includes @alice.following, @carol
    assert_not_includes @carol.followers, @alice
  end

  test "feed should have the right books or the right reports" do
    # aliceはbobをフォローしている
    @bob.books.each do |book|
      assert_includes @alice.feed(Book), book
    end
    @bob.reports.each do |report|
      assert_includes @alice.feed(Report), report
    end

    # bobはaliceをフォローしていない
    @alice.books.each do |book|
      assert_not_includes @bob.feed(Book), book
    end
    @alice.reports.each do |report|
      assert_not_includes @bob.feed(Report), report
    end
  end

  test "should get a GitHub user's avatar" do
    user = User.from_omniauth(@github_authentication)
    assert_equal(@github_email, user.email)
    assert_equal(@github_username, user.username)
    assert_equal(@github_username + "_profile.png", user.avatar.blob.filename.to_s)
  end
end
