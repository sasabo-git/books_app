# frozen_string_literal: true

class BooksController < ApplicationController
  include ResourceSetter

  before_action :set_resource, only: [:show]
  before_action :set_my_resource, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]

  NUMBER_PER_PAGE = 3

  # GET /books
  def index
    @books = Book.page(params[:page]).per(NUMBER_PER_PAGE)
  end

  # GET /books/1
  def show
    @user = User.find(@book.user_id)
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  def create
    @book = current_user.books.new(book_params)

    if @book.save
      redirect_to @book, notice: t("notice.create")
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: t("notice.update")
    else
      render :edit
    end
  end

  # DELETE /books/1
  def destroy
    if @book.destroy
      redirect_to books_url, notice: t("notice.destroy")
    else
      redirect_to books_url
    end
  end

  private
    def book_params
      params.require(:book).permit(:title, :memo, :author, :picture)
    end
end
