module UserFileModule
  USERS_FILE = 'data/users.txt'
  
  def read_users
    users = []
    begin
      if File.exist?(USERS_FILE)
        File.open(USERS_FILE, 'r') do |file|
          users = IO.readlines(file)
        end
      end
    rescue
      puts "Unable to read file."
      Main.new.main
    end
    users
  end

  def write_user(user_data)
    begin
      File.open(USERS_FILE, 'a') do |file|
        file.puts(user_data)
      end
    rescue
      puts "Unable to find file."
      Main.new.main
    end 
  end
end