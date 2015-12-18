class UserTask < ActiveRecord::Base
  belongs_to :course_subject
  belongs_to :user
  belongs_to :task
  belongs_to :user_subject
  belongs_to :user_course
end
