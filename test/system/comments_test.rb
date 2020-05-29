# frozen_string_literal: true

require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @alice_comment_book = comments(:alice_comment_for_bob_book)
    @alice_comment_report = comments(:alice_comment_for_bob_report)
    @bob_book = books(:bob_book)
    @bob_report = reports(:bob_report)
    @locale = "ja"
    @comment_body = "いいね！楽しそう〜"
  end

  test "view comments" do
    visit book_path(@locale, @bob_book)
    assert_text I18n.t("activerecord.models.comment")

    visit report_path(@locale, @bob_report)
    assert_text I18n.t("activerecord.models.comment")
  end

  test "create a comment" do
    login_as(@alice, scope: :user)

    visit book_path(@locale, @bob_book)
    fill_in I18n.t("activerecord.attributes.comment.body"), with: @comment_body
    click_button I18n.t("helpers.submit.create")
    assert_text I18n.t("notice.create")
    assert_text @comment_body

    visit report_path(@locale, @bob_report)
    fill_in I18n.t("activerecord.attributes.comment.body"), with: @comment_body
    click_button I18n.t("helpers.submit.create")
    assert_text I18n.t("notice.create")
    assert_text @comment_body
  end

  test "update a comment" do
    login_as(@alice, scope: :user)
    visit edit_book_comment_path(@locale, @bob_book, @alice_comment_book)
    fill_in I18n.t("activerecord.attributes.comment.body"), with: @comment_body
    click_button I18n.t("helpers.submit.update")
    assert_text I18n.t("notice.update")
    assert_text @comment_body

    visit edit_report_comment_path(@locale, @bob_report, @alice_comment_report)
    fill_in I18n.t("activerecord.attributes.comment.body"), with: @comment_body
    click_button I18n.t("helpers.submit.update")
    assert_text I18n.t("notice.update")
    assert_text @comment_body
  end

  test "delete a comment" do
    login_as(@alice, scope: :user)

    visit book_path(@locale, @bob_book)
    accept_confirm do
      within ".comment" do
        click_on I18n.t("link.destroy")
      end
    end
    assert_text I18n.t("notice.destroy")
    assert_no_text @comment_body

    visit report_path(@locale, @bob_report)
    accept_confirm do
      within ".comment" do
        click_on I18n.t("link.destroy")
      end
    end
    assert_text I18n.t("notice.destroy")
    assert_no_text @comment_body
  end
end
