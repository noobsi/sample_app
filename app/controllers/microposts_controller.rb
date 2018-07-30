class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = I18n.t "micropost.created"
      redirect_to root_url
    else
      @feed_items = current_user.microposts.order_micropost.page(params[:page])
                                .per Settings.micropost.paginate_per
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = I18n.t "micropost.delete"
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost.present?
  end
end
