class UserFollowsController < ApplicationController
  before_filter :authenticate_user!

  # POST /user/:id/follow.json
  def follow
    if UserFollow.follow(current_user.id, params[:id])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # DELETE /user/:id/unfollow.json
  def unfollow
    if UserFollow.unfollow(current_user.id, params[:id])
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
