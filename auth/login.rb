class Login
  include UserFileModule

  def login_details(email, password)
    users = read_users
    is_present = false

    users.each do |data|
      user = data.split("|")

      if (user[2] == email.strip && user[3] == password.strip)
        is_present = true
        puts 'Login Successfully.'
        if (user[4].include?('manager'))
          Manager.new(user[2]).menu
        elsif (user[4].include?('customer'))
          Customer.new(user[2]).menu
        end
      end
    end

    if (is_present == false)
      puts 'Invalid email or password.'
      Main.new.main
    end
  end
end