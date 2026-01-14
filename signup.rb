class Signup
	def signup_details(name, email, password, role)
		@name, @email, @password, @role = name, email, password, role.downcase
		#import users.txt here
		
		user_data=File.open("users.txt", "a+")

		#If we want to store data in array of hash than i think i have to 
		#take that approach like first users.txt -> content_var -> append userdata -> clean users.txt->
		#then save content_var in users.txt  || for cleaning data File.truncate(filename, 0)

		content = {"name"=>@name,"email"=>@email, "password"=>@password, "role"=>@role}
		user_data.syswrite(content)
		user_data.close
	end
end

puts "Signup"
puts "Enter your Name"
name = gets 
puts "Enter your Email"
email = gets
puts "Enter your Password"
password = gets
puts "Enter your Role"
role = gets

signup_o = Signup.new
signup_o.signup_details(name, email, password, role)

#send him to login
