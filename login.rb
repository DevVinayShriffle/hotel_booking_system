class Login
	def login_details(email, password)
		@email, @password = email, password
		#import users.txt here

		user_data=File.open("users.txt", "r")
			content = File.read("users.txt").split("},{")
			#It has problem like first and last element of content
			#has [{ | }] . so we have to write logic for removing that.

			content.each do |user|
				user =JSON.parse(user)
				if(user[email] == @email && user[password] == @password)
					puts "Login Successfully."
					if(user[role] == "manager")
						#send him to manager (user[name])
					else 
						#send him to user (user[name])
					end
				else
					puts "Invalid Credentials..."
				end
			end
		user_data.close
	end
end

puts "Login"
puts "Enter your Email"
email = gets
puts "Enter your Password"
password = gets

login_o = Login.new
login_o.login_details(email, password)