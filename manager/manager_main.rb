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


    def show_my_hotels
        hotels = read_file(HOTELS_FILE)
        my_hotels = []

        hotels.each do |hotel|
            data = hotel.split("|")
            my_hotels << data if parts[3] == @manager_email
        end

        if my_hotels.empty?
            puts "No hotels found"
            menu
            return
        end

        puts "Your Hotels:"
        my_hotels.each_with_index do |h, i|
            puts "#{i + 1}. #{h[1]} (#{h[2]})"
        end

        puts "Select hotel number:"
        index = gets.chomp.to_i - 1

        if my_hotels[index]
            hotel_dashboard(my_hotels[index][1])
        else
            puts "Invalid selection"
            menu
        end
    end

    def hotel_dashboard(hotel_name)
        puts "Hotel: #{hotel_name}"
        puts "1. View Room Stats"
        puts "2. Create Room"
        puts "3. Back"

        choice = gets.chomp

        if choice == "1"
            room_stats(hotel_name)
        elsif choice == "2"
            create_room(hotel_name)
        elsif choice == "3"
            menu
        else
            puts "Invalid choice"
            hotel_dashboard(hotel_name)
        end
    end


    def create_room(hotel_name)
        puts "Room Type (standard/deluxe/suite):"
        room_type = gets.chomp.downcase

        puts "Price per night:"
        price = gets.chomp

        puts "Total rooms:"
        total = gets.chomp.to_i

        rooms = read_file(ROOMS_FILE)
        room_id = rooms.length + 1

        data = "#{room_id}|#{hotel_name}|#{room_type}|#{price}|#{total}|#{total}"
        append_file(ROOMS_FILE, data)

        puts "Room created successfully"
        hotel_dashboard(hotel_name)
    end


    def room_stats(hotel_name)
        rooms = read_file(ROOMS_FILE)
        bookings = read_file(BOOKINGS_FILE)

        total_rooms = 0
        available_rooms = 0
        booking_count = 0
        cancel_count = 0

        rooms.each do |room|
            parts = room.split("|")
            if parts[1] == hotel_name
                total_rooms += parts[4].to_i
                available_rooms += parts[5].to_i
            end
        end

        bookings.each do |b|
            parts = b.split("|")
            if parts[1] == hotel_name
                parts[4] == "active" ? booking_count += 1 : cancel_count += 1
            end
        end

        puts "\nTotal Rooms: #{total_rooms}"
        puts "Available Rooms: #{available_rooms}"
        puts "Active Bookings: #{booking_count}"
        puts "Cancelled Bookings: #{cancel_count}"

        hotel_dashboard(hotel_name)
    end


end

# 1|Hotel Blue|Delhi|manager_email@gmail.com