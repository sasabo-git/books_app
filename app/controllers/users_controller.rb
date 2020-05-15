# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :following, :followers]
  before_action :set_user
  NUMBER_PER_PAGE = 10

  def show
  end

  def following
    @users = @user.following.page(params[:page]).per(NUMBER_PER_PAGE)
    render "show_follow"
  end

  def followers
    @users = @user.followers.page(params[:page]).per(NUMBER_PER_PAGE)
    render "show_follow"
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
