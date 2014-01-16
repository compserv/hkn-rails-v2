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
  ["mark", "mark@mark.com", "Mark", "Miyashita"],
  ["kacasey", "kacasey@berkeley.edu", "Kevin", "Casey"],
  ["kevintesterbot", "hazedkasey@gmail.com", "Night", "Stalker"],
  ["indreltesterbot", "indrel@indrel.indrel", "Tester", "testing"]
]

users.each do |user_info|
  user = User.create(username: user_info[0], email: user_info[1], password: "password", password_confirmation: "password", first_name: user_info[2], last_name: user_info[3], approved: true, phone_number: '123-456-7891', should_reset_session: true)
  user.member_semesters << current_member_semester
  puts "Created user with username: #{user.username} and email: #{user.email}."
end

# candidate tester
u = User.create(username: 'notaspammer', email: 'hazedcasey@gmail.com', password: "password", password_confirmation: "password", first_name: "candidate", last_name: "bob", approved: false, phone_number: '123-456-7891', should_reset_session: true)
v = User.create(username: 'approved', email: 'hihihi@gmail.com', password: "password", password_confirmation: "password", first_name: "candidate", last_name: "alice", approved: true, phone_number: '123-456-7891', should_reset_session: true)
new_role = Role.create(name: :candidate, role_type: :candidate, resource_type: MemberSemester.to_s, resource_id: MemberSemester.current.id)
v.add_position_for_semester_and_role_type(:candidate, MemberSemester.current, :candidate)
u.add_position_for_semester_and_role_type(:candidate, MemberSemester.current, :candidate)

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
  QuizQuestion.create(question: 'test question ' << num.to_s, answer: 'answer ' << num.to_s)
  puts "Added question number " + num.to_s + " to candidate quiz questions"
end

def initialize_mobile_carriers
  mobile_carriers = [
    {:name => "Alltel",             :sms_email => "@message.alltel.com"},
    {:name => "AT&T",               :sms_email => "@txt.att.net"},
    {:name => "Boost Mobile",       :sms_email => "@myboostmobile.com"},
    {:name => "Nextel",             :sms_email => "@messaging.nextel.com"},
    {:name => "Sprint",             :sms_email => "@messaging.sprintpcs.com"},
    {:name => "T-Mobile",           :sms_email => "@tmomail.net"},
    {:name => "US Cellular",        :sms_email => "@email.uscc.net"},
    {:name => "Verizon",            :sms_email => "@vtext.com"},
    {:name => "Virgin Mobile USA",  :sms_email => "@vmobl.com"},
  ]
  mobile_carriers.each do |mobile_carrier|
    MobileCarrier.find_or_create_by_name_and_sms_email(mobile_carrier)
  end
end

initialize_mobile_carriers

events = [
  ["Picnic", "Lots of fun", DateTime.yesterday, DateTime.now, "Big Fun", nil, nil, false, 999],
  ["GM2", "Must see!", DateTime.now.ago(2.days), DateTime.now, "Mandatory for Candidates", 'candidates', 'candidates', false, 999],
  ["HM1", "hm1", DateTime.tomorrow, DateTime.tomorrow, "Miscellaneous", 'committee_members', 'committee_members', true, 0],
  ["Paintball", "paintball", DateTime.now.in(3.hours), DateTime.now.in(4.hours), "Fun", 'officers', 'officers', true, 999]
]

events.each do |event|
  Event.create(title: event[0], description: event[1], start_time: event[2], end_time: event[3],
               event_type: event[4], view_permission_roles: event[5], rsvp_permission_roles: event[6],
               need_transportation?: event[7], max_rsvps: event[8])
  puts "Created event #{event[0]}"
  User.first.rsvp! Event.last.id
  puts "First user tried to RSVP to event #{Event.last.title}"
  #Candidate tries to rsvp
  if Event.last.can_rsvp? User.find_by_username('approved')
    User.find_by_username('approved').rsvp! Event.last.id
  end
end

