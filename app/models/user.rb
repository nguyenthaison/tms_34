class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_validation :default_password

  attr_accessor :remember_token
  enum role: [:trainee, :supervisor, :admin]

  has_many :activities, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :user_subjects, dependent: :destroy
  has_many :subjects, through: :user_subjects
  has_many :user_tasks, dependent: :destroy
  has_many :tasks, through: :user_tasks

  validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: 50}
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  scope :trainees, -> {trainee}
  scope :supervisors, -> {supervisor | admin}
  scope :excluded, -> user {where.not id: user.id}
  before_save :downcase_email
  has_secure_password

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(self.remember_token)
  end

  def authenticated? attribute_token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    self.remember_token = nil
    update_attributes remember_digest: nil
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def include? task
    self.user_tasks.map(&:task_id).include?(task.id)
  end

  private
  def downcase_email
    self.email = email.downcase
  end

  def default_password
    self.password = "password" if self.trainee? && !self.password_digest
  end
end
