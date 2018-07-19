class FollowingsController < ApplicationController
  before_action :find_user

  def index
    @title = t "users.following"
    @users = @user.following.page(params[:page])
                  .per Settings.micropost.paginate_per
  end
end
