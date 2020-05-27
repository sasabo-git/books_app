# frozen_string_literal: true

require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @locale = "ja"
    @title = "今日のできごと"
    @body = "今日は沢山勉強しました。"
  end

  test "view a reports index" do
    visit reports_path
    assert_text I18n.t("activerecord.models.report")
  end

  test "show a report" do
    visit report_path(@locale, reports(:alice_report))
    assert_text reports(:alice_report).title
  end

  test "create a report" do
    login_as(@alice, scope: :user)
    visit new_report_path(@locale)
    fill_in I18n.t("activerecord.attributes.report.title"), with: @title
    fill_in I18n.t("activerecord.attributes.report.body"), with: @body
    click_button I18n.t("helpers.submit.create")
    assert_text I18n.t("notice.create")
    assert_text @title
  end

  test "update a report" do
    login_as(@alice, scope: :user)
    visit edit_report_path(@locale, reports(:alice_report))
    fill_in I18n.t("activerecord.attributes.report.title"), with: @title
    fill_in I18n.t("activerecord.attributes.report.body"), with: @body
    click_button I18n.t("helpers.submit.update")
    assert_text I18n.t("notice.update")
    assert_text @title
  end

  test "should not update other user's report" do
    login_as(@alice, scope: :user)
    visit edit_report_path(@locale, reports(:bob_report))
    assert_text I18n.t("notice.no_authority")
  end

  test "delete a report" do
    login_as(@alice, scope: :user)
    expected_be_deleted_title = reports(:alice_report).title
    visit report_path(@locale, reports(:alice_report))
    accept_confirm do
      click_link I18n.t("link.destroy")
    end
    assert_text I18n.t("notice.destroy")
    assert_no_text expected_be_deleted_title
  end
end
