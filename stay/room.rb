require_relative '../manager/manager_file_module'
require_relative '../loader'

class Room
  # include CustomerFileModule
  include ManagerFileModule
  def initialize (email, role)
    @email = email
    @role = role
  end

  #list
  # def index
  # end

  def show_rooms(hotel_name)
      rooms = read_file(ROOMS_FILE)
      if rooms.empty?
        puts 'No rooms available'
        Customer.new(@email, @role).menu
        return
      end

      available = []

      puts "\nAvailable Rooms in #{hotel_name}:"

      rooms.each do |room|
        parts = room.split("|")
        if parts[1] == hotel_name && parts[5].to_i > 0
          available << parts
          puts "#{available.length}. #{parts[2]} | Price: $#{parts[3]} | Available: #{parts[5]}"
        end
      end

      if available.empty?
        puts 'No rooms available'
        Customer.new(@email).menu
        return
      end

      puts 'Select room_type to book:'
      index = gets.chomp.to_i - 1

      if available[index]
        book_room(hotel_name, available[index])
      else
        puts 'Invalid choice'
        Customer.new(@email).menu
      end
  end

  def create(hotel_name)
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
    Manager.new(@email).hotel_dashboard(hotel_name)
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

    Manager.new(@email).hotel_dashboard(hotel_name)
  end

  def update(hotel_name)
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
      Manager.new(@email).hotel_dashboard(hotel_name)
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
      Manager.new(@email).hotel_dashboard(hotel_name)
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
    Manager.new(@email).hotel_dashboard(hotel_name)
  end

  def book_room(hotel_name, room)
    puts 'Enter Check-in Date (YYYY-MM-DD):'
    check_in = gets.chomp

    puts 'Enter Check-out Date (YYYY-MM-DD):'
    check_out = gets.chomp

    total_amount = (check_out.slice(check_out.length-2, 2).to_i - check_in.slice(check_in.length-2, 2).to_i)*room[3].to_i

    bookings = read_file(BOOKINGS_FILE)
    booking_id = bookings.length + 1

    line = "#{booking_id}|#{hotel_name}|#{room[2]}|#{@customer_email}|#{check_in}|#{check_out}|active|#{total_amount}"
    append_file(BOOKINGS_FILE, line)

    update_room_availability(hotel_name, room[2], -1)

    # total_amount = (check_out.slice(check_out.length-2, 2).to_i - check_in.slice(check_in.length-2, 2).to_i)*room[3].to_i
    puts "Booking successful and Bill: $#{total_amount}"
    Customer.new(@email).menu
  end

  def update_room_availability(hotel, room_type, change)
    rooms = read_file(ROOMS_FILE)
    updated = []

    rooms.each do |r|
    parts = r.split("|")
      if parts[1] == hotel && parts[2] == room_type
        parts[5] = (parts[5].to_i + change).to_s
      end
      updated << parts.join("|")
    end

    write_all(ROOMS_FILE, updated)
  end

  # def destroy
  # end
end