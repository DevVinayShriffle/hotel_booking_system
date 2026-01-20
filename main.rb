require_relative 'loader'
class Main
  def initialize
    @input = Input.new
  end

  def main
    puts "Hotel Booking System".center(70, '=')
    puts "\n\nWelcome to the Hotel Booking System! Please Login or Signup yourself \n"
    puts '1. Signup'
    puts '2. Login'
    choice = gets.chomp.strip.to_i

    if (choice == 1)
      name = @input.input_name
      email = @input.input_email
      password = @input.input_password
      role = @input.input_role

      Signup.new.signup_details(name, email, password, role)
    elsif (choice == 2)
      email = @input.input_email
      password = @input.input_password

      Login.new.login_details(email, password)
    else
      puts "Invalid choice.\n"
      main
    end
  end
end

Main.new.main