# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to @commentable, notice: I18n.t("notice.create")
    else
      redirect_to @commentable, alert: I18n.t("alert.create")
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @commentable, notice: I18n.t("notice.update")
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    if @comment.destroy
      redirect_to @commentable, notice: I18n.t("notice.destroy")
    else
      redirect_to @commentable, alert: I18n.t("alert.destroy")
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def ensure_correct_user
      if current_user.comments.find_by(id: params[:id]).nil?
        redirect_to @commentable, notice: I18n.t("notice.no_authority")
      end
    end
end
