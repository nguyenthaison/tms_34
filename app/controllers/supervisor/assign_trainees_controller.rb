class Supervisor::AssignTraineesController < Supervisor::BaseController
  before_action :load_course, only: [:index, :show]
  before_action :verify_supervisor, only: [:show]
  before_action :verify_course_was_finished, only: [:show]

  def index
    @trainees = @course.users.trainees.paginate page: params[:page],
      per_page: 10
  end

  def show
    @trainees = User.trainees
  end

  private
  def verify_course_was_finished
    if @course.finished?
      flash[:danger] = t "flash.course_is_finished"
      redirect_to :back
    end
  end
end
