class MainFollow
	def get_auth_choice(choice)
		@choice = choice.downcase.strip  #login/signup
		case @choice
		when @choice == "login"
			#login.rb
		when @choice == "signup"
			#signup.rb
		else
		puts "Invalid choice"
		end
	end

	
end

# make it according to manager_main selection based on terminal

puts "Hotel Booking System"
puts "1. Login \n 2. Signup"
auth_choice= gets
m_f_o = MainFollow.new
m_f_o.get_auth_choice(auth_choice)
