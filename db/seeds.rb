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
v.add_position_for_semester_and_role_type(:candidate, MemberSemester.current, :candidate)

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
    MobileCarrier.where(mobile_carrier).first_or_create
  end
  puts "successfully initialized mobile carriers"
end

def initialize_indrel_database
  locations = [
    {name: '10 Evans', capacity: 200, comments: 'Largest lecture hall with a projector but never available.'},
    {name: '3117 Etcheverry', capacity: 30},
    {name: '3 Evans', capacity: 35},
    {name: '45 Evans', capacity: 25, comments: 'Not recommended, too small.'},
    {name: '60 Evans', capacity: 150, comments: 'A large room on the back of Evans with a nice projector'},
    {name: '75 Evans', capacity: 30},
    {name: '81 Evans', capacity: 30},
    {name: 'Wozniak Lounge', capacity: 100}
  ]
  locations.each do |location|
    Location.where(location).first_or_create
  end
  puts "successfully initialized locations"

  event_types = [{name: 'Infosession'}, {name: 'Resume Book Sale'}, {name: 'Tech Talk'}]
  event_types.each do |event|
    IndrelEventType.where(event).first_or_create
  end
  puts "successfully initialized indrel event types"

  companies = [
    {name: 'Apple', address: nil, website: 'apple.com', comments: 'Allison Rossi <allison_rossi@apple.com>'},
    {name: 'Box', address: nil, website: 'box.com', comments: 'Jennifer Nguyen jennifer@box.com'},
    {name: 'Brandcast', address: '2 Mint Plaza #702 San Francisco, CA 94103', website: nil, comments: 'Name of contact person: Dan Lynch Email: dan@brandcast.com'}

  ]
  companies.each do |company|
    Company.where(company).first_or_create
  end
  puts "successfully initialized a few indrel companies"

  contacts = [
    {name: 'Alicia Schetter', email: 'aschetter@salesforce.com', phone: '312.523.4603'},
    {name: 'Anja Hartmann', email: 'anja.hartmann@gs.com', phone: '212-902-4144'},
    {name: 'Brian Goodman', email: 'Brian.Goodman@deshawresearch.com', phone: 'N/A'},
    {name: 'Jason Lopatecki', email: 'jason@tubemogul.com', phone: '510.653.0664', cellphone: '415.297.1981'}
  ]
  contacts.each do |contact|
    Contact.where(contact).first_or_create
  end
  puts "successfully initialized a few indrel contacts"

  events = [
    {time: DateTime.civil(2011, 10, 12, 18, 0, 0, '-8'), indrel_event_type: IndrelEventType.find_by_name('Infosession'), officer: 'Ruchika Gupta'},
    {time: DateTime.civil(2010, 4, 20, 17, 0, 0, '-8'), food: "LaVal's pizza (10 boxes)", turnout: 25, location: Location.find_by_name('10 Evans'), indrel_event_type: IndrelEventType.find_by_name('Tech Talk'), prizes: 'Google Swags', officer: 'Ryosuke Niwa', comments: 'We had only 2 days to advertise. In the future, we need more time to advertise, and should contact the department. Also suggested to have techtalk with labs since they might be interested in what Google is doing. Did not charge for food (~$180) since the turnout was much worse than we expected.'},
    {time: DateTime.civil(2010, 4, 15, 18, 0, 0, '-8'), food: "LaVals (3 large pepperoni, 2 large cheese)", turnout: 25, indrel_event_type: IndrelEventType.find_by_name('Infosession'), officer: 'Rohan Nagesh', contact: Contact.find_by_name('Jason Lopatecki') }
  ]
  events.each do |event|
    IndrelEvent.where(event).first_or_create
  end
  puts "successfully initialized a few indrel events"

  puts "initialized indrel database"
end

initialize_mobile_carriers
initialize_indrel_database

events = [
  ["Picnic", "Lots of fun", DateTime.yesterday, DateTime.now, "Big Fun", nil, nil, false, 999],
  ["GM2", "Must see!", DateTime.now.ago(2.days), DateTime.now, "Mandatory for Candidates", 'candidates', 'candidates', false, 999],
  ["HM1", "hm1", DateTime.tomorrow, DateTime.tomorrow, "Miscellaneous", 'committee_members', 'committee_members', true, 0],
  ["Paintball", "paintball", DateTime.now.in(3.hours), DateTime.now.in(4.hours), "Fun", 'officers', 'officers', true, 999]
]

events.each do |event|
  Event.create(title: event[0], description: event[1], start_time: event[2], end_time: event[3],
               event_type: event[4], view_permission_roles: event[5], rsvp_permission_roles: event[6],
               need_transportation: event[7], max_rsvps: event[8], location: "Soda-Etchevery Breezeway")
  puts "Created event #{event[0]}"
  User.first.rsvp! Event.last.id
  puts "First user tried to RSVP to event #{Event.last.title}"
  #Candidate tries to rsvp
  if Event.last.can_rsvp? User.find_by_username('approved')
    User.find_by_username('approved').rsvp! Event.last.id
  end
end

