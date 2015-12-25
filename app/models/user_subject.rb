class UserSubject < ActiveRecord::Base
  include Taggable

  belongs_to :subject
  belongs_to :course
  belongs_to :user
  has_many :activities, dependent: :nullify
  has_many :user_tasks

  scope :by_user_of_subject, ->user, course{where course_id: course.id, user_id: user.id}

  accepts_nested_attributes_for :user_tasks, allow_destroy: true,
    reject_if: proc{|a| a[:task_id] == "0"}

  after_save :finish_subject

  private
  def finish_subject
    if status == false
      create_activity "Finish subject", user.id, subject.id, "finished_subject", course.id, id
      @tasks = self.subject.tasks
      @tasks.each do |task|
        UserTask.find_or_create_by!(user_id: self.user.id, task_id: task.id,user_subject_id: id)
      end
    end
  end

end
