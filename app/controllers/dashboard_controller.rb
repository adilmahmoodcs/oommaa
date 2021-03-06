class DashboardController < ApplicationController
  skip_after_action :verify_policy_scoped

  def index
    if current_user.has_right?(:view_all_employees)
      authorize :dashboard, :index?
      @shutdown_count = policy_scope(FacebookPost).shut_down.size

      @total_violations = policy_scope(FacebookPost).blacklisted_or_reported_to_facebook.
                                                     size

      violators_counts = {}
      policy_scope(FacebookPost).blacklisted_or_reported_to_facebook.
                                 pluck(:all_domains).
                                 flatten.
                                 group_by(&:itself).
                                 each { |k,v| violators_counts[k] = v.size }
      @violators = violators_counts.sort_by {|_key, value| value}.
                                    last(5).
                                    reverse
    else
      redirect_to employee_path(current_user.employee)
    end
  end
end
