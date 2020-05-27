# frozen_string_literal: true

require "application_system_test_case"

class RelationshipsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @carol = users(:carol)
    login_as(@alice, scope: :user)
  end

  test "view a stats of following and follower" do
    visit user_path(@locale, @alice)
    assert_text I18n.t("shared.stats.following")
    assert_text I18n.t("shared.stats.followers")
  end

  test "show following users" do
    visit following_user_path(@locale, @alice)
    assert_text I18n.t("shared.stats.following")
    assert_text "bob"
  end

  test "show followers" do
    visit followers_user_path(@locale, @bob)
    assert_text I18n.t("shared.stats.followers")
    assert_text "alice"
  end

  test "alice follow carol" do
    expected_alice_following_count = @alice.following.count + 1
    expected_carol_followers_count = @carol.followers.count + 1

    visit user_path(@locale, @carol)
    click_on I18n.t("users.follow.follow")

    assert_text expected_carol_followers_count.to_s + " " + I18n.t("shared.stats.followers")

    visit user_path(@locale, @alice)
    assert_text expected_alice_following_count.to_s + " " + I18n.t("shared.stats.following")
  end

  test "alice unfollow bob" do
    expected_alice_following_count = @alice.following.count - 1
    expected_bob_followers_count = @bob.followers.count - 1

    visit user_path(@locale, @bob)
    click_on I18n.t("users.unfollow.unfollow")
    assert_text expected_bob_followers_count.to_s + " " + I18n.t("shared.stats.followers")

    visit user_path(@locale, @alice)
    assert_text expected_alice_following_count.to_s + " " + I18n.t("shared.stats.following")
  end
end
