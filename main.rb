require_relative 'loader'
class Main
  def main
    puts "Hotel Booking System".center(70, '=')
    puts "\n\nWelcome to the Hotel Booking System! Please Login or Signup yourself \n"
    puts '1. Signup'
    puts '2. Login'

    choice = gets.chomp.to_i

    if (choice == 1)
      count = 1
      begin
        puts 'Enter your name'
        name = gets.chomp.strip
        if(name == "")
          if(count < 3)
            puts 'Please enter name first.'
            count += 1
            raise
          elsif (count == 3)
            puts 'You have reached maximum attempt.'
            main
          end
        end
      rescue
        retry
      end

      count = 1
      begin
        puts 'Enter your email'
        email = gets.chomp.strip.downcase
        result = Validation.new.email_validation(email)
        if(!result)
          if(count < 3)
            puts 'Please enter a valid email address.'
            count += 1
            raise
          elsif(count == 3)
            puts 'You have reached maximum attempt.'
            main
          end
        end
      rescue
        retry
      end

      count = 1
      begin
        puts 'Enter your Password'
        password = gets.chomp.strip

        result = Validation.new.password_validation(password)
        if(!result)
          if(count < 3)
            puts 'Password must have 6-8 characters long, one special character and a uppercase character.'
            count += 1
            raise
          else
            puts 'You have reached maximum attempt.'
            main
          end
        end
      rescue
        retry
      end

      count = 1
      begin
        puts 'Enter your Role(manager/customer)'
        role = gets.chomp.strip.downcase

        result = Validation.new.role_validation(role)
        if(!result)
          if(count < 3)
            puts 'Please enter a valid role.(manager/customer)'
            count += 1
            raise
          else
            puts 'You have reached maximum attempt.'
            main
          end
        end
      rescue
        retry
      end

      signup = Signup.new
      signup.signup_details(name, email, password, role)
      
    elsif (choice == 2)
      count = 1
      begin
        puts 'Enter your email'
        email = gets.chomp.strip.downcase
        result = Validation.new.email_validation(email)
        if(!result)
          if(count < 3)
            puts 'Please enter a valid email address.'
            count += 1
            raise
          elsif(count == 3)
            puts 'You have reached maximum attempt.'
            main
          end
        end
      rescue
        retry
      end

      count = 1
      begin
        puts 'Enter your Password'
        password = gets.chomp.strip
        result = Validation.new.password_validation(password)
        if(!result)
          if(count < 3)
            puts 'Password must have 6-8 characters long, one special character and a uppercase character.'
            count += 1
            raise
          else
            puts 'You have reached maximum attempt.'
            main
          end
        end
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