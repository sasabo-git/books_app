# frozen_string_literal: true

class ReportsController < ApplicationController
  include ResourceSetter

  before_action :set_resource, only: [:show]
  before_action :set_my_resource, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]

  NUMBER_PER_PAGE = 10

  # GET /reports
  def index
    @reports = Report.page(params[:page]).per(NUMBER_PER_PAGE)
  end

  # GET /reports/1
  def show
    @user = User.find(@report.user_id)
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  def create
    @report = current_user.reports.new(report_params)
    if @report.save
      redirect_to @report, notice: t("notice.create")
    else
      render :new
    end
  end

  # PATCH/PUT /reports/1
  def update
    if @report.update(report_params)
      redirect_to @report, notice: t("notice.update")
    else
      render :edit
    end
  end

  # DELETE /reports/1
  def destroy
    if @report.destroy
      redirect_to reports_url, notice: t("notice.destroy")
    else
      redirect_to reports_url
    end
  end

  private
    def report_params
      params.require(:report).permit(:title, :body)
    end
end
