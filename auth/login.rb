require_relative 'user_file_module'
class Login
    include UserFileModule
    def login_details(email, password)
        users = read_users
        is_present = false

        users.each do |data|
            user = data.split("|")
            if (user[2] == email && user[3] == password.strip)
                is_present = true
                puts "Login Successfully."
                if (user[4] == manager)
                    require_relative '../manager/manager_main.rb'
                    ManagerMain.new(user[2]).menu
                end
            end
        end

        puts "Invalid Credentials." unless is_present
        nil
    end
end

# data 1|Vinay|vinay@gmail.com|1234|manager