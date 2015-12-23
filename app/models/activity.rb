class Activity < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  ACTION = {FINISH_SUBJECT: "finish_subject"}
  belongs_to :user

  scope :activities_of_course, -> type_id {where "action_type LIKE '%course' AND type_id = ?", type_id}
  scope :activities_of_subject, -> type_id {where "action_type LIKE '%subject' AND type_id = ?", type_id}
  scope :type_id_of_user, -> user_id {where "user_id = ? AND action_type LIKE '%subject'", user_id}

  private
  def self.add_activity action_type, type_id, user_id
    Activity.create action_type: action_type, type_id: type_id, user_id: user_id
  end
end
