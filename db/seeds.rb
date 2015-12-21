# 5.times do |n|
#   subject = Subject.first
#   name = Faker::Name.title
#   description = Faker::Lorem.paragraphs(5).join(" <br /> ")
#   Task.create!(name: name, description: description, subject_id: subject.id)
# end
# 4.times do |n|
#   name  = Faker::Name.name
#   email = "admin-#{n+1}@framgia.com"
#   User.create!(name:  name, email: email, password: "admin123",
#     password_confirmation: "admin123", role: :admin)
# end
supervisor_id = 2
admin = 56
c = Course.first
UserCourse.create(user_id: 2, course_id: c.id, is_active: false)
UserCourse.create(user_id: 56, course_id: c.id, is_active: false)
# 50.times do |n|
#   name  = Faker::Name.name
#   email = "trainee-#{n+1}@tms34.com"
#   User.create!(name:  name, email: email, password: "trainee",
#     password_confirmation: "trainee", role: :trainee)
# end

# 10.times do |n|
#   user = User.trainee.find(17+n)
#   course = Course.first
#   UserCourse.create!(user_id: user.id , course_id: course.id, is_active: false)
# end

