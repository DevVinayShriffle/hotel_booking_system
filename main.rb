class Main
	def main
		require_relative 'auth/signup.rb'
		require_relative 'auth/login.rb'
		require_relative 'utils/validation'
		puts "Hotel Booking System".center(70, '=')
		puts "\n\nWelcome to the Hotel Booking System! Please Login or Signup yourself \n"
		puts '1. Signup'
		puts '2. Login'

		choice = gets.chomp.to_i

		if (choice == 1)
			puts 'Enter your name'
			name = gets.chomp

			puts 'Enter your email'
			email = gets.chomp

			puts 'Enter Your Password'
			password = gets.chomp

			puts 'Enter your Role(manager/customer)'
			role = gets.chomp

			signup = Signup.new
			signup.signup_details(name, email, password, role)

		elsif (choice == 2)
			count = 1
			begin
				puts 'Enter your email'
				email = gets.chomp
				result = Validation.new.email_validation(email)
				
				if(!result && count < 3)
					puts 'Please enter a valid email address.'
					count += 1
				elsif(!result && count > 3)
					puts 'You have reached maximum attempt.'
					main
				end
				raise
			rescue
				retry
			end

			count = 1
			begin
				puts 'Enter your Password'
				password = gets.chomp

				result = Validation.new.password_validation(password)
				
				if(result == 0 && count < 3)
					puts 'Password must have 6-8 characters long, one special character and a uppercase character.'
					count += 1
				else
					puts 'You have reached maximum attempt.'
					main
				end
				raise
			rescue
				retry
			end

			login = Login.new
			login.login_details(email, password)

		else
			puts "Invalid choice.\n"
			main
		end
	end
end

Main.new.main