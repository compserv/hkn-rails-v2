# Users
users = [
  ["kacasey", "kacasey@berkeley.edu"],
  ["kevintesterbot", "hazedkasey@gmail.com"],
  ["mark", "mark@mark.com"]
]

users.each do |user_info|
  user = User.create(username: user_info[0], email: user_info[1], password: "password", password_confirmation: "password")
  puts "Created user #{user.id} with username: #{user.username} and email: #{user.email}."
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

