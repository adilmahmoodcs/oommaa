class DashboardController < ApplicationController
  skip_after_action :verify_policy_scoped

  def index
    authorize :dashboard, :index?
  end
end
