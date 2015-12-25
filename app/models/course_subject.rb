class CourseSubject < ActiveRecord::Base
  enum status: [:pending, :starting, :finished]
  belongs_to :course
  belongs_to :subject
  has_many :course_subject_tasks
  has_many :user_tasks

  validates :course_id, uniqueness: {scope: :subject_id}
  accepts_nested_attributes_for :subject

  before_create :set_default_status
  after_save :add_user_subject
  before_destroy :delete_user_subject

  private
  def set_default_status
    self.status = :pending if status.nil?
  end

  def add_user_subject
    @trainees = course.users.trainees
    @trainees.each do |trainee|
      UserSubject.find_or_create_by(subject_id: subject.id, user_id: trainee.id, course_id: course.id)
    end
  end

  def delete_user_subject
    subject.user_subjects.where(course_id: course.id).delete_all
  end

end
