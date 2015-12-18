class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_course, :authorize_user, only: :show
  def index
    @user_courses = current_user.user_courses.paginate page: params[:page], per_page: 10
  end

  def show
    @members = @course.users.trainees
    @subjects = @course.subjects
    @user_subjects = UserSubject.by_user_of_subject(@course,current_user)
    @activities = Activity.activities_of_course(@course)
      .paginate page: params[:page], per_page: 10
  end

  private

  def load_course
    @course = Course.find params[:id]
  end

  def authorize_user
    unless @course.users.include? current_user
      redirect_to root_path
    end
  end
end
