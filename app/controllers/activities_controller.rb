class ActivitiesController < ApplicationController
  def index
    authorize PublicActivity::Activity
    @activities =
      policy_scope(PublicActivity::Activity).includes(:trackable, :owner).
                                             order(created_at: :desc).
                                             page(params[:page]).
                                             per(100)
  end
end
