# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(
	first_name: 'Admin',
	last_name: 'Admin',
	role: 'Admin',
	email: 'admin@mail.fr',
	password: 'adminadmin',
	password_confirmation: 'adminadmin'
)

User.create(
	first_name: 'Matthieu',
	last_name: 'Clor',
	role: 'User',
	email: 'user@mail.fr',
	password: 'useruser',
	password_confirmation: 'useruser'
)

User.create(
	first_name: 'Nicolas',
	last_name: 'Miannay',
	role: 'User',
	email: 'user@mail.fr',
	password: 'useruser',
	password_confirmation: 'useruser'
)