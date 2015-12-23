class UserSubject < ActiveRecord::Base
  include Taggable

  belongs_to :subject
  belongs_to :user
  belongs_to :course
  has_many :user_tasks

  scope :by_user_of_subject, ->user, course{where course_id: course.id, user_id: user.id}

  accepts_nested_attributes_for :user_tasks, allow_destroy: true,
    reject_if: proc{|a| a[:task_id] == "0"}

  after_save :finish_subject

  private
  def finish_subject
    if status == false
      @type_id = Activity.where(["user_id = ? AND action_type LIKE '%SUBJECT'", user.id]).pluck(:type_id)
      unless @type_id.include? subject.id
        Activity.add_activity Activity::ACTION[:FINISH_SUBJECT], subject.id, user.id
      end
      @tasks = self.subject.tasks
      @tasks.each do |task|
        UserTask.find_or_create_by!(user_id: self.user.id, task_id: task.id,user_subject_id: id)
      end
    end
  end

end
