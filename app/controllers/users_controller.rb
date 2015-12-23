class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.trainees.paginate page: params[:page]
  end

  def show
    @user = User.find params[:id]
    @activities = @user.activities.latest.paginate page: params[:page], per_page: 5
  end

  def update
    if @user.update user_params
      flash[:success] = t "users.update"
      redirect_to root_url
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "sessions.new.danger"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user?(@user)
  end
end
