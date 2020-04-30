# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]
  before_action :ensure_correct_user, { only: [:edit, :update, :destroy] }

  NUMBER_PER_PAGE = 3

  # GET /books
  def index
    @books = Book.page(params[:page]).per(NUMBER_PER_PAGE)
  end

  # GET /books/1
  def show
    @book = Book.find_by(id: params[:id])
    @user = User.find_by(id: @book.user_id)
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
    @book = Book.new(
      **book_params,
      user_id: current_user.id
    )

    if @book.save
      redirect_to @book, notice: I18n.t("notice.create")
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: I18n.t("notice.update")
    else
      render :edit
    end
  end

  # DELETE /books/1
  def destroy
    if @book.destroy
      redirect_to books_url, notice: I18n.t("notice.destroy")
    else
      redirect_to books_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :memo, :author, :picture)
    end

    def ensure_correct_user
      @book = Book.find_by(id: params[:id])
      unless @book.user_id == current_user.id
        redirect_to books_path, notice: I18n.t("notice.no_authority")
      end
    end
end
