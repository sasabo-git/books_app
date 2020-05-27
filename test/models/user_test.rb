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
    assert_not @alice.following?(@carol)

    @alice.follow(@carol)
    assert @alice.following?(@carol)
    assert @carol.followers.include?(@alice)

    @alice.unfollow(@carol)
    assert_not @alice.following?(@carol)
  end

  test "feed should have the right books or the right reports" do
    # aliceはbobをフォローしている
    @bob.books.each do |book|
      assert @alice.feed(Book).include?(book)
    end
    @bob.reports.each do |report|
      assert @alice.feed(Report).include?(report)
    end

    # bobはaliceをフォローしていない
    @alice.books.each do |book|
      assert_not @bob.feed(Book).include?(book)
    end
    @alice.reports.each do |report|
      assert_not @bob.feed(Report).include?(report)
    end
  end

  test "should get a GitHub user's avatar" do
    user = User.from_omniauth(@github_authentication)
    assert_equal(@github_email, user.email)
    assert_equal(@github_username, user.username)
    assert_equal(@github_username + "_profile.png", user.avatar.blob.filename.to_s)
  end
end
