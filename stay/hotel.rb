class Hotel
  include ManagerFileModule

  def initialize (email, role)
    @email = email
    @role = role
  end

  def index
    if (@role.include?('manager'))
      hotels = read_file(HOTELS_FILE)
      my_hotels = []

      hotels.each do |hotel|
        data = hotel.split("|")
        my_hotels << data if data[3].include?(@email)
      end

      if my_hotels.empty?
        puts 'No any hotels found'
        return Manager.new(@email).menu
      end

      return my_hotels

    elsif (@role.include?('customer'))
      view_all_hotels
    end
  end

  def create
  #  count = 1
  #   begin
  #    puts 'Enter Hotel name'
  #    hotel_name = gets.chomp.strip
  #    if(hotel_name == "")
  #     if(count < 3)
  #      puts 'Please enter Hotel name first.'
  #      count += 1
  #      raise
  #     elsif (count == 3)
  #      puts 'You have reached maximum attempt.'
  #      Manager.new(@email).menu
  #     end
  #    end
  #   rescue
  #    retry
  #   end
    hotel_name = Input.new.input_hotel_name(@email)
    
  #  count = 1
  #   begin
  #     puts 'Enter Location'
  #     location = gets.chomp.strip
  #     if(location == "")
  #       if(count < 3)
  #         puts 'Please enter Location first.'
  #         count += 1
  #         raise
  #       elsif (count == 3)
  #         puts 'You have reached maximum attempt.'
  #         Manager.new(@email).menu
  #       end
  #     end
  #   rescue
  #     retry
  #   end
    location = Input.new.input_location(@email)

   hotels = read_file(HOTELS_FILE)
   hotel_id = hotels.length + 1

   data = "#{hotel_id}|#{hotel_name}|#{location}|#{@email}"

   append_file(HOTELS_FILE, data)
   puts 'Hotel created successfully.'
   Manager.new(@email).menu
  rescue
   Manager.new(@email).menu
  end

  def view_all_hotels
    hotels = read_file(HOTELS_FILE)

    if hotels.empty?
      puts 'No hotels available'
      return Customer.new(@email).menu
    end

    puts "\nHotels:"
    hotels.each_with_index do |h, i|
      parts = h.split("|")
      puts "#{i + 1}. #{parts[1]} (#{parts[2]})"
    end

    puts 'Select hotel number:'
    puts 'If you want to exit Enter * or # key'
    index = gets.chomp.strip

    if(index == "*" || index == "#")
      Customer.new(@email).menu
    end
    index = index.to_i - 1

    if hotels[index]
      hotel_name = hotels[index].split("|")[1]
      Room.new(@email, @role).show_rooms(hotel_name)
    else
      puts 'Invalid selection'
      Customer.new(@email).menu
    end
  end
end