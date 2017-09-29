class ActivitiesController < ApplicationController
  def index
    authorize PublicActivity::Activity
    @activities =
      if params[:activity].present?
        policy_scope(PublicActivity::Activity).where(owner_id: params[:activity][:owner_id]).
                                             includes(:trackable, :owner).
                                             order(created_at: :desc).
                                             page(params[:page]).
                                             per(100)
      else
        policy_scope(PublicActivity::Activity).includes(:trackable, :owner).
                                             order(created_at: :desc).
                                             page(params[:page]).
                                             per(100)
      end
  end
end
