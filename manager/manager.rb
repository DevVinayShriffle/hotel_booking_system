require_relative 'manager_file_module'
class Manager
  include ManagerFileModule
  def initialize (email)
    @manager_email = email
  end

  def menu
    puts "\nManager menu: "
    puts '1. Create Hotels'
    puts '2. View My Hotels'
    puts '3. Logout'

    choice = gets.chomp.to_i
    case choice
    when 1
      create_hotels
    when 2
      show_my_hotels
    when 3
      puts 'Logout Successfully'
      require_relative '../main'
      Main.new.main
    else
      puts 'Invalid Choice'
      menu
    end
  end


  def create_hotels
   puts 'Enter Hotel Name ' 
   hotel_name = gets.chomp

   puts 'Enter Location ' 
   location = gets.chomp

   hotels = read_file(HOTELS_FILE)
   hotel_id = hotels.length + 1

   data = "#{hotel_id}|#{hotel_name}|#{location}|#{@manager_email}"

   append_file(HOTELS_FILE, data)
   puts 'Hotel created successfully.'
   menu
  rescue
   menu
  end


  def show_my_hotels
    hotels = read_file(HOTELS_FILE)
    my_hotels = []

    hotels.each do |hotel|
      data = hotel.split("|")
      my_hotels << data if data[3].include?(@manager_email)
    end

    if my_hotels.empty?
      puts 'No any hotels found'
      menu
      return
    end

    puts "\nYour Hotels:"
    my_hotels.each_with_index do |h, i|
      puts "#{i + 1}. #{h[1]} (#{h[2]})"
    end

    puts 'Select hotel number:'
    puts 'If you want to exit Enter * key'
    index = gets.chomp


    if(index.strip == "*")
      menu
    end

    index = index.to_i - 1
    if my_hotels[index]
      hotel_dashboard(my_hotels[index][1])
    else
      puts 'Invalid selection'
      menu
    end      
  end

  def hotel_dashboard(hotel_name)
    puts "\nHotel: #{hotel_name}"
    puts '1. View Room Stats'
    puts '2. Create Room'
    puts '3. Add Room'
    puts '4. Back'

    choice = gets.chomp.to_i

    case choice
    when 1
      room_stats(hotel_name)
    when 2
      create_room(hotel_name)
    when 3
      add_room(hotel_name)
    when 4
      menu
    else
      puts 'Invalid choice'
      hotel_dashboard(hotel_name)
    end
  end


  def create_room(hotel_name)
    puts 'Room Type (standard/deluxe/suite):'
    room_type = gets.chomp.downcase

    puts 'Price per night($):'
    price = gets.chomp

    puts 'Total rooms:'
    total = gets.chomp.to_i

    rooms = read_file(ROOMS_FILE)
    room_id = rooms.length + 1

    data = "#{room_id}|#{hotel_name}|#{room_type}|#{price}|#{total}|#{total}"
    append_file(ROOMS_FILE, data)

    puts 'Room created successfully'
    hotel_dashboard(hotel_name)
  end


  def add_room(hotel_name)
    rooms = read_file(ROOMS_FILE)
    hotel_rooms = []
    rooms.each do |room|
      parts = room.strip.split("|")
      if parts[1] == hotel_name
        hotel_rooms << parts
      end
    end

    if hotel_rooms.empty? 
      puts 'No rooms found for this hotel'
      hotel_dashboard(hotel_name)
      return
    end

    puts "\nRoom Types:"

    hotel_rooms.each_with_index do |r, i|
      puts "#{i + 1}. #{r[2]} | Total: #{r[4]} | Available: #{r[5]}"
    end

    puts 'Select room number to add rooms:'
    index = gets.chomp.to_i - 1
    if hotel_rooms[index].nil?
      puts 'Invalid selection'
      hotel_dashboard(hotel_name)
      return
    end

    puts 'Enter number of rooms to add:'
    add_count = gets.chomp.to_i
    updated_rooms = []
    rooms.each do |room|
      parts = room.strip.split("|")
      if parts[1] == hotel_name && parts[2] == hotel_rooms[index][2]
        parts[4] = (parts[4].to_i + add_count).to_s
        parts[5] = (parts[5].to_i + add_count).to_s
      end
      updated_rooms << parts.join("|")
    end
    File.open(ROOMS_FILE, 'w') do |f|
      updated_rooms.each { |r| f.puts(r) }
    end
    puts 'Rooms added successfully'
    hotel_dashboard(hotel_name)
  end


  def room_stats(hotel_name)
    rooms = read_file(ROOMS_FILE)
    bookings = read_file(BookingS_FILE)

    total_rooms = 0
    available_rooms = 0
    booking_count = 0
    cancel_count = 0
    room_type = []

    rooms.each do |room|
      parts = room.split("|")
      if parts[1] == hotel_name
        total_rooms += parts[4].to_i
        available_rooms += parts[5].to_i
        room_type << parts[2]
      end
    end

    bookings.each do |b|
      parts = b.split("|")
      if parts[1] == hotel_name
        parts[6] == 'active' ? booking_count += 1 : cancel_count += 1
      end
    end

    puts "\nTotal Rooms: #{total_rooms} #{room_type}"
    puts "Available Rooms: #{available_rooms}"
    puts "Active Bookings: #{booking_count}"
    puts "Cancelled Bookings: #{cancel_count}"

    hotel_dashboard(hotel_name)
  end
end


# 1|Hotel Blue|Delhi|manager_email@gmail.com