# frozen_string_literal: true

require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)

    @username = "Tanaka.Ichiro_01"
    @email = "tanaka@exsample.com"
    @introduction = "趣味は読書です。よろしくお願いします。"
    @avatar = "#{Rails.root}/test/fixtures/files/avatar.png"
    @zip = "1234567"
    @address = "県市町123"
    @password = "password"
    @github_username = "mockuser"

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: "github",
      uid: "1234",
      info: {
        name: @github_username,
        email: "mock@example.com",
        image: "https://placehold.jp/150x150.png"
      }
    })
  end

  test "show a user" do
    login_as(@alice, scope: :user)
    visit user_path(@locale, @alice)
    assert_text I18n.t("users.show.profile")
    assert_text @alice.introduction
  end

  test "create a user" do
    visit new_user_registration_path
    fill_in I18n.t("activerecord.attributes.user.username"), with: @username
    fill_in I18n.t("activerecord.attributes.user.email"), with: @email
    fill_in I18n.t("activerecord.attributes.user.password"), with: @password
    fill_in I18n.t("activerecord.attributes.user.password_confirmation"), with: @password
    click_button I18n.t("users.registrations.new.sign_up")
    assert_text I18n.t("devise.registrations.signed_up")
    assert_text @username
  end

  test "update a user" do
    login_as(@alice, scope: :user)
    visit edit_user_registration_path
    fill_in I18n.t("activerecord.attributes.user.username"), with: @username
    fill_in I18n.t("activerecord.attributes.user.email"), with: @email
    fill_in I18n.t("activerecord.attributes.user.introduction"), with: @introduction
    attach_file I18n.t("activerecord.attributes.user.avatar"), @avatar
    fill_in I18n.t("activerecord.attributes.user.zip"), with: @zip
    fill_in I18n.t("activerecord.attributes.user.address"), with: @address
    fill_in I18n.t("activerecord.attributes.user.password"), with: @password
    fill_in I18n.t("activerecord.attributes.user.password_confirmation"), with: @password
    click_button I18n.t("users.registrations.edit.update")
    assert_text I18n.t("users.registrations.updated")
    within ".profile" do
      assert_text @username
    end
  end

  test "delete a user" do
    login_as(@alice, scope: :user)
    visit edit_user_registration_path
    accept_confirm do
      click_on I18n.t("users.registrations.edit.cancel_my_account")
    end
    assert_text I18n.t("users.registrations.destroyed")
    assert_no_text @alice.username
  end

  test "sign in with GitHub" do
    visit new_user_registration_path
    click_on I18n.t("users.shared.links.sign_in_with_provider", provider: "GitHub")
    assert_text I18n.t("devise.omniauth_callbacks.success", kind: "github")
    within "header" do
      assert_text @github_username
    end
  end

  test "sign in" do
    visit new_user_session_path
    fill_in "user_login", with: @alice.username
    fill_in I18n.t("activerecord.attributes.user.password"), with: "password"
    click_button I18n.t("users.shared.links.sign_in")
    assert_text I18n.t("users.sessions.signed_in")
    within "header" do
      assert_text @alice.username
    end
  end

  test "click sign in link and sign up link" do
    visit root_path
    within "header" do
      click_on I18n.t("shared.header.sign_up")
    end
    assert_selector "h2", text: I18n.t("users.registrations.new.sign_up")

    within "header" do
      click_on I18n.t("shared.header.sign_in")
    end
    assert_selector "h2", text: I18n.t("users.sessions.new.sign_in")
  end

  test "click show link and edit link of user" do
    login_as(@alice, scope: :user)
    visit root_path
    click_on I18n.t("shared.header.profile")
    assert_text I18n.t("users.show.profile")

    click_on I18n.t("shared.header.edit_profile")
    text = I18n.t("users.registrations.edit.title", resource: "#{I18n.t('activerecord.models.user')}")
    assert_selector "h2", text: text
  end
end
