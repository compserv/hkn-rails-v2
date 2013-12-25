# Member Semesters
member_semesters = [
  ["Spring", 2013],
  ["Fall", 2013],
  ["Spring", 2014],
]

member_semesters.each do |member_semester|
  new_member_semester = MemberSemester.create(season: member_semester[0], year: member_semester[1])
  puts "Created new member semester: #{new_member_semester.name}."
end

current_member_semester = MemberSemester.last

# Users
users = [
  ["mark", "mark@mark.com"],
  ["kacasey", "kacasey@berkeley.edu"],
  ["kevintesterbot", "hazedkasey@gmail.com"],
]

users.each do |user_info|
  user = User.create(username: user_info[0], email: user_info[1], password: "password", password_confirmation: "password")
  user.member_semesters << current_member_semester
  puts "Created user with username: #{user.username} and email: #{user.email}."
end

# Roles
officer_roles = [
  "pres",
  "vp",
  "treas",
  "rsec",
  "csec",
  "deprel",
  "bridge",
  "act",
  "compserv",
  "studrel",
  "tutoring",
  "serv",
  "alumrel",
]

officer_roles.each do |role|
  new_role = Role.create(name: role, resource_type: "officer")
  puts "Created new role: #{new_role.name}."
end

officer_to_position = [
  [User.find(1), :compserv],
  [User.find(2), :tutoring],
  [User.find(3), :pres],
]

officer_to_position.each do |user, role|
  semester = current_member_semester
  user.add_role_for_semester(role, semester)
  puts "Added role: #{role} to user: #{user.username} for semester: #{semester.name}."
end
