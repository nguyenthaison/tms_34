module ApplicationHelper
  def full_title page_title = ""
    base_title = t("application.general.base_title")
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def link_to_remove_fields label, f
    field = f.hidden_field :_destroy
    link = link_to label, "#", onclick: "remove_fields(this)", remote: true
    field + link
  end

  def link_to_add_fields label, f, assoc
    new_obj = f.object.class.reflect_on_association(assoc).klass.new
    fields = f.fields_for assoc, new_obj, child_index: "new_#{assoc}" do |builder|
      render "#{assoc.to_s.singularize}_fields", f: builder
    end
    link_to label, "#", onclick: "add_fields(this, \"#{assoc}\",
      \"#{escape_javascript(fields)}\")", remote: true
  end

  def percent_complete_subject subject, user_subject
    percent = subject.tasks.count > 0 ?
      user_subject.user_tasks.count * 100.0 / subject.tasks.count : 0
      number_to_percentage percent, precision: 0
  end

  def trainee_progress user
    course = user.user_courses.find_by(is_active: true).course
    user_courses = course.user_courses
    @task_finishs = 0
    user_courses.each do |user_course|
      @task_finishs = @task_finishs + user_course.user_tasks.size
    end
    subjects = course.subjects
    @number_of_tasks = 0
    subjects.each do |subject|
      @number_of_tasks = @number_of_tasks + subject.tasks.size
    end
    percent = @number_of_tasks > 0 ? @task_finishs * 100.0 / @number_of_tasks : 0
    number_to_percentage percent, precision: 0
  end
end
