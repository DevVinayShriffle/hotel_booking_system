require_relative 'manager_file_module'
class ManagerMain
    include ManagerFileModule
    def initialize (email)
        @manager_email = email
    end

    def menu
        puts "Manager menu: "
        puts "1. Create Hotels"
        puts "2. View My Hotels"
        puts "3. Logout"

        choice = gets.chomp
        if (choice == "1")
            create_hotels
        elsif (choice == "2")
            show_my_hotels
        elsif
            puts "Logout Successfully"
        else
            puts "Invalid Choice"
            menu
        end
    end


    def create_hotels
       puts "Enter Hotel Name " 
       hotel_name = gets.chomp

       puts "Enter Location " 
       location = gets.chomp

       hotels = read_file(HOTELS_FILE)
       hotel_id = hotels.length + 1

       data = "#{hotel_id}|#{hotel_name}|#{location}|#{@manager_email}"
       
       append_file(HOTELS_FILE, data)
       puts "Hotel created successfully."
    end

end

# 1|Hotel Blue|Delhi|manager_email@gmail.com