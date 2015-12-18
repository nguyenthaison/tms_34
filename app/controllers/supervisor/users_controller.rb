class Supervisor::UsersController < ApplicationController
  before_action :load_user, except: [:create, :new]

  def index
    @users = User.trainees.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "supervisor.users.success_create_trainee"
      redirect_to supervisor_users_path
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js{@user}
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "supervisor.users.update_flash_success"
      redirect_to supervisor_users_path
    else
      flash[:danger] = t "supervisor.users.update_flash_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "supervisor.users.delete_flash_success"
    else
      flash[:danger] = t "supervisor.users.delete_flash_fail"
    end
    redirect_to :back
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :role
  end

  def load_user
    @user = User.find_by_id params[:id]
  end
end
