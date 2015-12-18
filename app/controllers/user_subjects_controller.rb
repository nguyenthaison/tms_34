class UserSubjectsController < ApplicationController
  before_action :load_user_subject
  before_action :authenticate_user!

  def update
    @user_subject.status = false if params[:finish]
      if @user_subject.update_attributes user_subject_params
        flash[:success] = t ".success"
      else
        flash[:danger] = t ".errors"
      end
      redirect_to user_subject_path @user_subject
    end


  def show
    @tasks = @subject.tasks
    @user_id = @user_subject.user_id
    @tasks.each do |task|
      @user_subject.user_tasks.find_or_initialize_by task_id: task.id,
        user_id: @user_id
    end
    @activities = Activity.activities_of_subject(@subject)
      .paginate page: params[:page], per_page: 10
  end

  private
  def load_user_subject
    @user_subject = UserSubject.find params[:id]
    @subject = @user_subject.subject
  end

  def user_subject_params
    params.require(:user_subject).permit user_tasks_attributes: [:id, :user_id,
      :task_id]
  end
end
