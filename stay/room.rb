require_relative '../manager/manager_file_module'
require_relative '../customer/customer_file_module'
require_relative '../loader'

class Room
  include CustomerFileModule
  include ManagerFileModule

  def initialize (email, role)
    @email = email
    @role = role
  end

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
      puts 'If you want to return then pleae enter * or #'
      index = gets.chomp.strip
      if(index == '*' || index == '#')
        Customer.new(@email).menu
      end
      index = index.to_i - 1

      if available[index]
        book_room(hotel_name, available[index])
      else
        puts 'Invalid choice'
        Customer.new(@email).menu
      end
  end

  def create(hotel_name)
    count = 0
    begin
      puts 'Room Type (standard/deluxe/suite):'
      room_type = gets.chomp.strip.downcase

      if (room_type == "")
        if(count < 2)
          puts 'Please enter room type first.'
          count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(@email).hotel_dashboard(hotel_name)
        end
      end

      if(!['standard', 'deluxe', 'suite'].include?(room_type))
        if(count < 2)
          puts 'Please enter valid room type.'
          count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(@email).hotel_dashboard(hotel_name)
        end
      end
    rescue
      retry
    end

    count = 0
    begin
      puts 'Price per night($):'
      price = gets.chomp.strip.to_i
      
      if((!price || price <= 0))
        if(count < 2)
          puts 'Please enter valid price.'
          count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(@email).hotel_dashboard(hotel_name)
        end
      end
    rescue
      retry
    end

    count = 0
    begin
      puts 'Total rooms:'
      total = gets.chomp.strip.to_i
      
      if((!total || total <= 0))
        if(count < 2)
          puts 'Please enter total rooms.'
          count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(@email).hotel_dashboard(hotel_name)
        end
      end
    rescue
      retry
    end

    rooms = read_file(ROOMS_FILE)
    rooms.each do |line|
      parts = line.split('|')
      if(parts[1] == hotel_name && parts[2] == room_type)
        puts "You don't need to create same room type. Add Rooms in existing room type."
        Manager.new(@email).hotel_dashboard(hotel_name)
      end
    end

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
      Manager.new(@email).hotel_dashboard(hotel_name)
      return
    end

    puts "\nRoom Types:"

    hotel_rooms.each_with_index do |r, i|
      puts "#{i + 1}. #{r[2]} | Total: #{r[4]} | Available: #{r[5]}"
    end

    puts 'Select room number to add rooms:'
    puts 'If you want to return enter * or #'

    index = gets.chomp.strip
    if(index == '*' || index == '#')
      return Manager.new(@email).hotel_dashboard(hotel_name)
    end

    index = index.to_i - 1
    if hotel_rooms[index].nil?
      puts 'Invalid selection'
      return Manager.new(@email).hotel_dashboard(hotel_name)
    end

    count = 0
    begin
      puts 'Enter number of rooms to add:'
      add_count = gets.chomp.strip.to_i
      
      if((!add_count || add_count <= 0))
        if(count < 2)
          puts 'Please enter valid room numbers.'
          count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(@email).hotel_dashboard(hotel_name)
        end
      end
    rescue
      retry
    end
    
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
    count = 1
    while count <= 3
      puts 'Enter Check-in Date (YYYY-MM-DD):'
      input = gets.chomp.strip

      begin
        check_in = Date.parse(input)
        break
      rescue
        puts 'Invalid date format.'
      end

      if count == 3
        puts 'Maximum attempts reached.'
        Customer.new(@email).menu
        return
      end

      count += 1
    end

    count = 1
    while count <= 3
      puts 'Enter Check-out Date (YYYY-MM-DD):'
      input = gets.chomp.strip

      begin
        check_out = Date.parse(input)
        if check_out > check_in
          break
        else
          puts 'Check-out date must be after check-in date.'
        end
      rescue
        puts 'Invalid date format.'
      end

      if count == 3
        puts 'Maximum attempts reached.'
        Customer.new(@email).menu
        return
      end

      count += 1
    end

    nights = (check_out - check_in).to_i
    total_amount = nights * room[3].to_i

    bookings = read_file(BOOKINGS_FILE)
    booking_id = bookings.length + 1

    line = "#{booking_id}|#{hotel_name}|#{room[2]}|#{@email}|#{check_in}|#{check_out}|active|#{total_amount}"
    append_file(BOOKINGS_FILE, line)

    update_room_availability(hotel_name, room[2], -1)

    puts "Booking successful!"
    puts "Total nights: #{nights}"
    puts "Bill Amount: $#{total_amount}"

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
end