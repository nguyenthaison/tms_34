class AddCourseIdAndUserSubjectIdToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :course_id, :integer
    add_column :activities, :user_subject_id, :integer
  end
end
