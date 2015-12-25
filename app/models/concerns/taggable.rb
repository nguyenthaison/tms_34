module Taggable
  extend ActiveSupport::Concern

  private
  def create_activity description, user_id, type_id, action_type, course_id, user_subject_id
    Activity.create description: description, user_id: user_id, type_id: type_id,
      action_type: action_type, course_id: course_id, user_subject_id: user_subject_id
  end
end
