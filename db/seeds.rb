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
  ["kacasey", "kacasey@berkeley.edu"],
  ["kevintesterbot", "hazedkasey@gmail.com"],
  ["mark", "mark@mark.com"]
]

users.each do |user_info|
  user = User.create(username: user_info[0], email: user_info[1], password: "password", password_confirmation: "password")
  user.member_semesters << current_member_semester
  puts "Created user with username: #{user.username} and email: #{user.email}."
end

# Roles
officer_roles = [
  "Pres",
  "VP",
  "Treas",
  "Rsec",
  "Csec",
  "Deprel",
  "Bridge",
  "Act",
  "Compserv",
  "Studrel",
  "Tutoring",
  "Serv",
  "Alumrel",
]

officer_roles.each do |role|
  new_role = Role.create(name: role, resource_type: "officer")
  puts "Created new role: #{new_role.name}."
end
