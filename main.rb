require_relative 'auth/signup.rb'
require_relative 'auth/login.rb'
puts "Hotel Booking System"
puts "1. Signup"
puts "2. Login"

choice = gets.chomp
puts choice.class
if (choice == "1")
	puts "Enter your name"
	name = gets.chomp

	puts "Enter your email"
	email = gets.chomp

	puts "Enter Your Password"
	password = gets.chomp

	puts "Enter your Role(manager/customer)"
	role = gets.chomp

	signup = Signup.new
	signup.signup_details(name, email, password, role)

elsif (choice == "2")
	puts "Enter your email"
	email = gets.chomp

	puts "Enter your Password"
	password = gets.chomp

	login = Login.new
	login.login_details(email, password)

else
	puts "Invalid choice."
end