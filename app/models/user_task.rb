class UserTask < ActiveRecord::Base
  include Taggable

  belongs_to :course_subject
  belongs_to :user
  belongs_to :task
  belongs_to :user_subject
  belongs_to :user_course

  after_create :create_task_activity

  private
  def create_task_activity
    create_activity "Finish task", user.id, task_id, "finished_task"
  end
end
