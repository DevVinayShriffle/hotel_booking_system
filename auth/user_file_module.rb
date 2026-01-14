module UserFileModule
    USERS_FILE = "data/users.txt"
    
    def read_users
        users = []
        if File.exist?(USERS_FILE)
            File.open(USERS_FILE, 'r') do |file|
                IO.foreach(file) {|line| users << line.strip}
            end
        end
        users
    end

    def write_user(user_data)
        File.open(USERS_FILE, 'a') do |file|
            file.puts(user_data)
        end
    end

end