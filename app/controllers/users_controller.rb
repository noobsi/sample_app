class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.order_user.page(params[:page])
                 .per Settings.user_setting.paginate_per
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_mail
      flash[:success] = t "activate_mail.noti"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    redirect_to root_url unless @user.present? || @user.activated?
    @microposts = @user.microposts.order_micropost
                       .page(params[:page]).per Settings.micropost.paginate_per
    @build_relationship = current_user.active_relationships.build
    @find_relationship = current_user.active_relationships
                                     .find_by followed_id: @user.id
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".delete_success"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".pls_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
