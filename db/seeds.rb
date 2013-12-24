# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:username => 'kacasey', :email => 'kacasey@berkeley.edu', :password => '12345678', :password_confirmation => '12345678')
User.create(:username => 'kevintesterbot', :email => 'hazedcasey@gmail.com', :password => '12345678', :password_confirmation => '12345678')
Role.create(:name => 'compserve', :resource_type => 'officer')