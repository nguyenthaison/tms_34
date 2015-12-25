class UserCourse < ActiveRecord::Base
  include Taggable

  belongs_to :course
  belongs_to :user

  has_many :user_tasks
  validates :course_id, uniqueness: {scope: :user_id}
  validate :only_active_one_course_for_trainee

  scope :active, -> {where is_active: true}

  before_save :default_value
  after_save :create_course_starting_activity, :create_course_assignment_log, :add_user_subject
  before_destroy :delete_user_subject
  after_destroy :create_course_finished

  private
  def default_value
    self.is_active = true
  end

  def only_active_one_course_for_trainee
    if user.trainee? && user.user_courses.active.size > 0
      errors.add :actived, I18n.t("flash.only_assigned_to_one_active_course", user: user.name)
    end
  end

  def create_course_starting_activity
    create_activity "Course is starting", user.id, course.id, "course_starting", course.id, nil
  end

  def create_course_finished
    create_activity "Course is finished", user.id, course.id, "course_finished", course.id, nil
  end

  def create_course_assignment_log
    create_activity "Course assign", user.id, course.id, "course_assignment", course.id, nil
  end

  def delete_user_subject
    subject.user_subjects.where(course_id: course.id).delete_all
  end

  def add_user_subject
    @subjects = course.subjects
    if user.trainee?
      @subjects.each do |subject|
        UserSubject.create_with(status: true).find_or_create_by(subject_id: subject.id, user_id: user.id,
          course_id: course.id)
      end
    end
  end

end

