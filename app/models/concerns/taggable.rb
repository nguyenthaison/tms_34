module Taggable
  extend ActiveSupport::Concern

  private
  def create_activity description, user_id, type_id, action_type
    Activity.create(description: description, user_id: user_id, type_id: type_id, action_type: action_type)
  end
end
