class ReportsController < ApplicationController
  def team_production
    authorize :report, :team_production?

    @users = User.admin
    @from = Date.parse(params[:from]).beginning_of_day if params[:from].present?
    @to = Date.parse(params[:to]).end_of_day if params[:to].present?
  end

  def employees_data
    authorize :report, :team_production?

    @users = User.admin
    @from = Date.parse(params[:from]).beginning_of_day if params[:from].present?
    @to = Date.parse(params[:to]).end_of_day if params[:to].present?
  end
end
