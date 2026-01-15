require_relative 'customer_file_module'

class Customer
  include CustomerFileModule

  def initialize(customer_email)
    @customer_email = customer_email
  end

  def menu
    puts "\nCustomer Menu"
    puts '1. View Hotels'
    puts '2. My Bookings'
    puts '3. Cancelled Bookings'
    puts '4. Logout'

    choice = gets.chomp.to_i

    case choice
    when 1
      view_hotels
    when 2
      view_bookings
    when 3
      view_cancelled_bookings
    when 4
      puts 'Logged out'
      require_relative '../main'
      Main.new.main
    else
      puts 'Invalid choice'
      menu
    end 
  end

  def view_hotels
      hotels = read_file(HOTELS_FILE)

      if hotels.empty?
        puts 'No hotels available'
        menu
        return
      end

      puts "\nHotels:"
      hotels.each_with_index do |h, i|
        parts = h.split("|")
        puts "#{i + 1}. #{parts[1]} (#{parts[2]})"
      end

      puts 'Select hotel number:'
      puts 'If you want to exit Enter * key'
      index = gets.chomp


      if(index.strip == "*")
        menu
      end

      index = index.to_i - 1

      if hotels[index]
        hotel_name = hotels[index].split("|")[1]
        show_rooms(hotel_name)
      else
        puts 'Invalid selection'
        menu
      end
  end


  def show_rooms(hotel_name)
      rooms = read_file(ROOMS_FILE)
      if rooms.empty?
        puts 'No rooms available'
        menu
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
        menu
        return
      end

      puts 'Select room_type to book:'
      index = gets.chomp.to_i - 1

      if available[index]
        book_room(hotel_name, available[index])
      else
        puts 'Invalid choice'
        menu
      end
  end



  def book_room(hotel_name, room)
    puts 'Enter Check-in Date (YYYY-MM-DD):'
    check_in = gets.chomp

    puts 'Enter Check-out Date (YYYY-MM-DD):'
    check_out = gets.chomp

    bookings = read_file(BOOKINGS_FILE)
    booking_id = bookings.length + 1

    line = "#{booking_id}|#{hotel_name}|#{room[2]}|#{@customer_email}|#{check_in}|#{check_out}|active"
    append_file(BOOKINGS_FILE, line)

    update_room_availability(hotel_name, room[2], -1)

    total_amount = (check_out.slice(check_out.length-2, 2).to_i - check_in.slice(check_in.length-2, 2).to_i)*room[3].to_i
    puts "Booking successful and Bill: $#{total_amount}"
    menu
  end



  def view_bookings
    bookings = read_file(BOOKINGS_FILE)
    my_bookings = []

    puts "\nMy Bookings:"
    bookings.each do |b|
      parts = b.split("|")
      if parts[3] == @customer_email && parts[6] == "active"
        my_bookings << parts
        puts "#{my_bookings.length}.  #{parts[1]} | #{parts[2]} | #{parts[4]} to #{parts[5]}"
      end
    end

    if my_bookings.empty?
      puts 'No active bookings'
      menu
      return
    end

    puts 'Select booking number to cancel:'
    puts 'If you want to exit Enter * key'
    index = gets.chomp
    if(index.strip == "*")
      menu
    end

    index = index.to_i - 1

    if my_bookings[index]
      cancel_booking(my_bookings[index][0])
    else
      puts 'Invalid choice'
      menu
    end
  end



  def cancel_booking(booking_id)
    bookings = read_file(BOOKINGS_FILE)
    updated = []

    bookings.each do |b|
      parts = b.split("|")
      if parts[0] == booking_id && parts[6] == 'active'
        parts[6] = 'cancelled'
        update_room_availability(parts[1], parts[2], 1)
      end
      updated << parts.join("|")
    end

    write_all(BOOKINGS_FILE, updated)

    puts 'Booking cancelled successfully'
    menu
  end



  def view_cancelled_bookings
    bookings = read_file(BOOKINGS_FILE)

    puts "\nCancelled Bookings:"
    bookings.each do |b|
      parts = b.split("|")
      if parts[3] == @customer_email && parts[6] == 'cancelled'
        puts "#{parts[1]} | #{parts[2]} | #{parts[4]} to #{parts[5]}"
      end
    end

    menu
  end

#check and change logic here
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


