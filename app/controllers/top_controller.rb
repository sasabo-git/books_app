# frozen_string_literal: true

class TopController < ApplicationController
  NUMBER_PER_PAGE = 5

  def index
    if user_signed_in?
      @feed_books = current_user.feed_books.page(params[:page]).per(NUMBER_PER_PAGE)
    end
  end
end
