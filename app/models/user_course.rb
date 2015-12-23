class UserCourse < ActiveRecord::Base
  include Taggable

  belongs_to :course
  belongs_to :user

  has_many :user_tasks
  validates :course_id, uniqueness: {scope: :user_id}
  validate :only_active_one_course_for_trainee

  scope :active, -> {where is_active: true}

  after_save :create_course_pending_activity, :create_course_starting_activity
  after_destroy :create_course_finished

  private
  def only_active_one_course_for_trainee
    if user.trainee? && user.user_courses.active.size > 0
      errors.add :actived, I18n.t("flash.only_assigned_to_one_active_course", user: user.name)
    end
  end

  def create_course_pending_activity
    create_activity "Course is pending", user.id, course.id, "course_pending"
  end

  def create_course_starting_activity
    create_activity "Course is starting", user.id, course.id, "course_starting"
  end

  def create_course_finished
    create_activity "Course is finished", user.id, course.id, "course_finished"
  end

end

