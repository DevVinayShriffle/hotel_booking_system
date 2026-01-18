require_relative '../manager/manager_file_module'
require_relative '../loader'

class Hotel
  include ManagerFileModule
  def initialize (email, role)
    @email = email
    @role = role
  end


  def index
    if (@role.include?("manager"))
      hotels = read_file(HOTELS_FILE)
      my_hotels = []

      hotels.each do |hotel|
        data = hotel.split("|")
        my_hotels << data if data[3].include?(@email)
      end

      if my_hotels.empty?
        puts 'No any hotels found'
        return Manager.new.menu
      end

      return my_hotels

      # puts "\nYour Hotels:"
      # my_hotels.each_with_index do |h, i|
      #   puts "#{i + 1}. #{h[1]} (#{h[2]})"
      # end
    elsif (@role.include?("customer"))
      view_hotels
    end
  end


  def create
   puts 'Enter Hotel Name ' 
   hotel_name = gets.chomp

   puts 'Enter Location ' 
   location = gets.chomp

   hotels = read_file(HOTELS_FILE)
   hotel_id = hotels.length + 1

   data = "#{hotel_id}|#{hotel_name}|#{location}|#{@email}"

   append_file(HOTELS_FILE, data)
   puts 'Hotel created successfully.'
   Manager.new(@email).menu
  rescue
   Manager.new(@email).menu
  end


  def show
  end

  def update
  end

  def destroy
  end

  def view_hotels
      hotels = read_file(HOTELS_FILE)

      if hotels.empty?
        puts 'No hotels available'
        Customer.new(@email).menu
        return
      end

      puts "\nHotels:"
      hotels.each_with_index do |h, i|
        parts = h.split("|")
        puts "#{i + 1}. #{parts[1]} (#{parts[2]})"
      end

      puts 'Select hotel number:'
      puts 'If you want to exit Enter * or # key'
      index = gets.chomp


      if(index.strip == "*" || index.strip == "#")
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



