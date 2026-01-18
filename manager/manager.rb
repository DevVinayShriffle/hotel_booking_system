require_relative '../loader'

class Manager
  def initialize (email)
    @manager_email = email
    @role = "manager"
  end

  def menu
    puts "\nManager menu: "
    puts '1. Create Hotels'
    puts '2. View My Hotels'
    puts '3. Logout'

    choice = gets.chomp.to_i
    case choice
    when 1
      Hotel.new(@manager_email, @role).create
    when 2
      show_my_hotels
    when 3
      puts 'Logout Successfully'
      Main.new.main
    else
      puts 'Invalid Choice'
      menu
    end
  end

  def show_my_hotels
    my_hotels = Hotel.new(@manager_email, @role).index

    puts "\nYour Hotels:"
    my_hotels.each_with_index do |h, i|
      puts "#{i + 1}. #{h[1]} (#{h[2]})"
    end

    puts 'Select hotel number:'
    puts 'If you want to exit Enter * or # key'
    index = gets.chomp

    if(index.strip == "*" || index.strip == "#")
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
      Room.new(@manager_email, @role).room_stats(hotel_name)
    when 2
      Room.new(@manager_email, @role).create(hotel_name)
    when 3
      Room.new(@manager_email , @role).add_room(hotel_name)
    when 4
      menu
    else
      puts 'Invalid choice'
      hotel_dashboard(hotel_name)
    end
  end
end