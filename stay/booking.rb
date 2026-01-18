# require_relative '../manager/manager_file_module'
require_relative '../loader.rb'
require_relative '../customer/customer_file_module.rb'

class Booking
  include CustomerFileModule
	def initialize(email, role)
		@email = email
		@role = role
	end

	def index
    bookings = read_file(BOOKINGS_FILE)
    my_bookings = []

    puts "\nMy Bookings:"
    bookings.each do |b|
      parts = b.split("|")
      if parts[3] == @email && parts[6] == "active"
        my_bookings << parts
        puts "#{my_bookings.length}.  #{parts[1]} | #{parts[2]} | #{parts[4]} to #{parts[5]} | $#{parts[7]}"
      end
    end

    if my_bookings.empty?
      puts 'No active bookings'
      Customer.new(@email).menu
      return
    end

    puts 'Select booking number to cancel:'
    puts 'If you want to exit Enter * or # key'
    index = gets.chomp
    if(index.strip == "*" || index.strip == "#")
      Customer.new(@email).menu
    end

    index = index.to_i - 1

    if (my_bookings[index])
      cancel_booking(my_bookings[index][0])
    else
      puts 'Invalid choice'
      Customer.new(@email).menu
    end
  end

  def cancel_booking(booking_id)
    bookings = read_file(BOOKINGS_FILE)
    updated = []
    
    bookings.each do |b|
      parts = b.split("|")
      if parts[0] == booking_id && parts[6] == 'active'
        parts[6] = 'cancelled'
        Room.new(@email, @role).update_room_availability(parts[1], parts[2], 1)
      end
      updated << parts.join("|")
    end

    write_all(BOOKINGS_FILE, updated)

    puts 'Booking cancelled successfully'
    Customer.new(@email).menu
  end

  def view_cancelled_bookings
    bookings = read_file(BOOKINGS_FILE)

    puts "\nCancelled Bookings:"

    if bookings.empty?
      puts 'No cancelled bookings'
      Customer.new(@email).menu
      return
    end

    bookings.each do |b|
      parts = b.split("|")
      if parts[3] == @email && parts[6] == 'cancelled'
        puts "#{parts[1]} | #{parts[2]} | #{parts[4]} to #{parts[5]} | $#{parts[7]}"
      end
    end
    Customer.new(@email).menu
  end
end