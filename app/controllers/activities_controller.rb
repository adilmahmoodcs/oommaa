class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.includes(:trackable, :owner).
                                           order(created_at: :desc).
                                           page(params[:page]).
                                           per(100)
  end
end
