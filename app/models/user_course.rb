class UserCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  validates :course_id, uniqueness: {scope: :user_id}
  validate :only_active_one_course_for_trainee

  scope :active, -> {where is_active: true}

  private
  def only_active_one_course_for_trainee
    if user.trainee? && user.user_courses.active.size > 0
      errors.add :actived, I18n.t("flash.only_assigned_to_one_active_course", user: user.name)
    end
  end
end
