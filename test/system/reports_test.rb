# frozen_string_literal: true

require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @locale = "ja"
    @title = "今日のできごと"
    @body = "今日は沢山勉強しました。"
  end

  test "view a reports index" do
    visit reports_path
    assert_text I18n.t("activerecord.models.report")
  end

  test "show a report" do
    visit report_path(@locale, @alice.reports.first)
    assert_text I18n.t("activerecord.models.report")
  end

  test "create a report" do
    login_as(@alice, scope: :user)
    visit new_report_path(@locale, @alice.reports.first)
    fill_in I18n.t("activerecord.attributes.report.title"), with: @title
    fill_in I18n.t("activerecord.attributes.report.body"), with: @body
    click_button I18n.t("helpers.submit.create")
    assert_text I18n.t("notice.create")
    assert_text @title
  end

  test "update a report" do
    login_as(@alice, scope: :user)
    visit edit_report_path(@locale, @alice.reports.first)
    fill_in I18n.t("activerecord.attributes.report.title"), with: @title
    fill_in I18n.t("activerecord.attributes.report.body"), with: @body
    click_button I18n.t("helpers.submit.update")
    assert_text I18n.t("notice.update")
    assert_text @title
  end

  test "should not update other user's report" do
    login_as(@alice, scope: :user)
    visit edit_report_path(@locale, @bob.reports.first)
    assert_text I18n.t("notice.no_authority")
  end

  test "delete a report" do
    login_as(@alice, scope: :user)
    expected_be_deleted_title = Report.first.title
    visit reports_path
    accept_confirm do
      first("tbody tr").click_link I18n.t("link.destroy")
    end
    assert_text I18n.t("notice.destroy")
    assert_no_text expected_be_deleted_title
  end

  test "click link of reports index, show, create, edit" do
    login_as(@alice, scope: :user)

    # index link
    visit root_path
    click_on I18n.t("shared.header.reports")
    assert_selector "h1", text: I18n.t("activerecord.models.report")

    # show link
    click_on @alice.reports.first.title
    assert_selector "h1", text: I18n.t("reports.show.report_information")

    # create link
    visit reports_path
    click_on I18n.t("link.new_report")
    assert_selector "h1", text: I18n.t("reports.new.new_report")

    # edit link
    visit reports_path
    first("tbody tr").click_link I18n.t("link.edit")
    assert_selector "h1", text: I18n.t("reports.edit.editing_report")
  end
end
