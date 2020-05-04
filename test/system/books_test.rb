# frozen_string_literal: true

require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @title = "自転車に乗ろう"
    @memo = "自転車好きな著者による自転車のススメ"
    @author = "田中一郎"
    @picture = "#{Rails.root}/test/fixtures/files/avatar.png"
  end

  test "view a index of books" do
    visit books_path
    assert_text I18n.t("activerecord.models.book")
  end

  test "show a book" do
    visit book_path(@locale, @alice.books.first)
    assert_text I18n.t("books.show.book_information")
  end

  test "create a book" do
    login_as(@alice, scope: :user)
    visit new_book_path(@locale, @alice.books.first)
    fill_in I18n.t("activerecord.attributes.book.title"), with: @title
    fill_in I18n.t("activerecord.attributes.book.memo"), with: @memo
    fill_in I18n.t("activerecord.attributes.book.author"), with: @author
    attach_file I18n.t("activerecord.attributes.book.picture"), @picture
    click_button I18n.t("helpers.submit.create")
    assert_text I18n.t("notice.create")
    assert_text @title
  end

  test "update a book" do
    login_as(@alice, scope: :user)
    visit edit_book_path(@locale, @alice.books.first)
    fill_in I18n.t("activerecord.attributes.book.title"), with: @title
    fill_in I18n.t("activerecord.attributes.book.memo"), with: @memo
    fill_in I18n.t("activerecord.attributes.book.author"), with: @author
    attach_file I18n.t("activerecord.attributes.book.picture"), @picture
    click_button I18n.t("helpers.submit.update")
    assert_text I18n.t("notice.update")
    assert_text @title
  end

  test "should not update other user's book" do
    login_as(@alice, scope: :user)
    visit edit_book_path(@locale, @bob.books.first)
    assert_text I18n.t("notice.no_authority")
  end

  test "delete a book" do
    login_as(@alice, scope: :user)
    expected_be_deleted_title = Book.first.title
    visit books_path
    accept_confirm do
      first("tbody tr").click_link I18n.t("link.destroy")
    end
    assert_text I18n.t("notice.destroy")
    assert_no_text expected_be_deleted_title
  end

  test "click link of books index, show, create, edit" do
    login_as(@alice, scope: :user)

    # index link
    visit root_path
    click_on I18n.t("shared.header.books")
    assert_selector "h1", text: I18n.t("activerecord.models.book")

    # show link
    first("tbody tr").click_link I18n.t("link.show")
    assert_selector "h1", text: I18n.t("books.show.book_information")

    # create link
    visit books_path
    click_on I18n.t("link.new_book")
    assert_selector "h1", text: I18n.t("books.new.new_book")

    # edit link
    visit books_path
    first("tbody tr").click_link I18n.t("link.edit")
    assert_selector "h1", text: I18n.t("books.edit.editing_book")
  end
end
