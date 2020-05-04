# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :following, :followers]
  NUMBER_PER_PAGE = 10

  def show
    @user = User.find(params[:id])
  end

  def following
    @title = I18n.t("shared.stats.following")
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(NUMBER_PER_PAGE)
    render "show_follow"
  end

  def followers
    @title = I18n.t("shared.stats.followers")
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(NUMBER_PER_PAGE)
    render "show_follow"
  end
end
