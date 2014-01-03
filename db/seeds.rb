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
  ["indreltesterbot", "indrel@indrel.indrel"]
]

users.each do |user_info|
  user = User.create(username: user_info[0], email: user_info[1], password: "password", password_confirmation: "password", first_name: "tester", last_name: "testing")
  user.member_semesters << current_member_semester
  puts "Created user with username: #{user.username} and email: #{user.email}."
end

# Roles
execs = [
  "pres",
  "vp",
  "treas",
  "rsec",
  "csec",
  "deprel",
]

committees = [
  "bridge",
  "act",
  "compserv",
  "studrel",
  "indrel",
  "tutoring",
  "serv",
  "alumrel",
]

officer_roles = execs + committees

MemberSemester.all.each do |semester|
  officer_roles.each do |role|
    new_role = Role.create(name: role, role_type: "officer", resource_type: MemberSemester.to_s, resource_id: semester.id)
    puts "Created new officer role: #{new_role.name} for semester: #{semester.name}."
  end

  committees.each do |role|
    new_role = Role.create(name: role, role_type: "committee_member", resource_type: MemberSemester.to_s, resource_id: semester.id)
    puts "Created new committee member role: #{new_role.name} for semester: #{semester.name}."
  end
end

officer_to_position = [
  [User.find(1), Role.current(:compserv)],
  [User.find(2), Role.current(:tutoring)],
  [User.find(3), Role.current(:pres)],
  [User.find(4), Role.current(:indrel)]
]

officer_to_position.each do |user, role|
  semester = MemberSemester.find(role.resource_id)
  user.add_role_for_semester(role.name, semester)
  puts "Added role: #{role.name} to user: #{user.username} for semester: #{semester.name}."
end

(1..4).each do |num|
  q = QuizQuestion.new(question: 'test question ' << num.to_s,
                       answer: 'answer ' << num.to_s)
  q.save
  puts "Added question number " + num.to_s + " to candidate quiz questions"
end
