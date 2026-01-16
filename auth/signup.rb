require_relative 'user_file_module'
class Signup
  include UserFileModule
  def signup_details (name, email, password, role)
    users = read_users
    users.each do |data|
      user = data.split("|")
      if(user[2] == email)
        puts 'Email already exist.'
        Main.new.main
      end
    end

    id = users.length + 1
    role = role.downcase.strip

    user_data = "#{id}|#{name}|#{email}|#{password}|#{role}"

    write_user(user_data)
    puts "User Registered Successfully.\n"
    
    Main.new.main
  end
end

# data 1|Vinay|vinay@gmail.com|1234|manager