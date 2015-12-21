class Course < ActiveRecord::Base
  enum status: [:pending, :starting, :finished]

  belongs_to :owner, class_name: User.name, foreign_key: "user_id"
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :course_subjects
  has_many :subjects, through: :course_subjects
  has_many :user_subjects, dependent: :destroy

  validates :description, presence: true, length: {minimum: 100}
  validate  :end_date_greate_or_equal_than_start_date
  validates :name, presence: true, length: {maximum: 50}
  validates :status, presence: true
  validates :owner, presence: true

  accepts_nested_attributes_for :course_subjects, allow_destroy: true,
    reject_if: proc {|a| a[:subject_id].blank? || a[:subject_id] == "0"}

  accepts_nested_attributes_for :user_courses, allow_destroy: true,
    reject_if: proc {|a| a[:user_id].blank? || a[:user_id] == "0"}

  scope :latest, -> {order created_at: :desc}
  scope :active, -> {where "is_active = ?" , true}

  after_save :add_user_subject
  after_save :un_active_user_when_finish

  private
  def add_user_subject
    if self.starting?
      self.subjects.each do |subject|
        self.users.trainees.each do |user|
          UserSubject.find_or_create_by(user_id: user.id, subject_id: subject.id, course_id: id, status: true)
        end
      end
    end
  end

  def end_date_greate_or_equal_than_start_date
    if start_date.nil? || end_date.nil?
      errors.add(:start_date, I18n.t("errors.course.blank"))
    elsif start_date > end_date
      errors.add(:start_date, I18n.t("errors.course.start_end"))
    end
  end

  def un_active_user_when_finish
    if self.finished?
      self.user_courses.update_all(is_active: false)
    end
  end
end
