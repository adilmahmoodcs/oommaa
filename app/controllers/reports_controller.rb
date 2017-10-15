class ReportsController < ApplicationController
  def team_production
    authorize :report, :team_production?

    @users = User.admin
    @from = Date.parse(params[:from]).beginning_of_day if params[:from].present?
    @to = Date.parse(params[:to]).end_of_day if params[:to].present?
  end

  def employees_data
    authorize :report, :team_production?

    @q = policy_scope(Employee).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @employees = @q.result

    respond_to do |format|
      format.html do
        # @posts = @posts.page(params[:page])
      end

      format.csv do
        send_data EmployeesReportCSVExporter.new(@employees, params[:employee]).call,
                  filename: "employees_report_export_#{Time.now.to_i}.csv"
      end
    end
  end
end
