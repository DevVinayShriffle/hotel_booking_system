require_relative '../loader'

class Customer
  def initialize(customer_email)
    @customer_email = customer_email
    @role = "customer"
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
      Hotel.new(@customer_email, @role).index
    when 2
      Booking.new(@customer_email, @role).index
    when 3
      Booking.new(@customer_email, @role).view_cancelled_bookings
    when 4
      puts 'Logged out'
      Main.new.main
    else
      puts 'Invalid choice'
      menu
    end 
  end
end