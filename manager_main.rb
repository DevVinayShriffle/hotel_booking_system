require 'tty-prompt'
class ManagerMain

	def choices
		prompt = TTY::Prompt.new
		choices = [
  		'create hotel',
  		'see hotel',
		]
		selected_option = prompt.select("Please choose an option:", choices)
		puts "You selected: #{selected_option}"

		if(selected_option == "create hotel")
			get_hotel_details
		else 
			see_hotel
		end
	end



	def get_hotel_details
        puts "Enter Hotel name"
        @hotel_name = gets
        puts "Enter Hotel Location"
        @hotel_location = gets
        create_hotel
	end



	def create_hotel
		# We have to also store manager name for distinguish
		hotel_data=File.open("hotels.txt", "a+")
			content = {"hotel_name"=>@hotel_name, "hotel_location"=>@hotel_location}
			hotel_data.syswrite(content)
		hotel_data.close
		choices
	end


	def get_all_hotels
		all_hotels = []  #local var for storing hotels
		hotel_data=File.open("hotels.txt", "r")
			content = File.read("hotels.txt").split("},{")
			#It has problem like first and last element of content
			#has [{ | }] . so we have to write logic for removing that.

			content.each do |hotel|
				hotel =JSON.parse(hotel)  #apply condition later based on manager 
				all_hotels << hotel[hotel_name]
			end
		hotel_data.close
		return all_hotels
	end


	def see_hotel
		# all_hotels = []  #local var for storing hotels

		# hotel_data=File.open("hotels.txt", "r")
		# 	content = File.read("hotels.txt").split("},{")
		# 	#It has problem like first and last element of content
		# 	#has [{ | }] . so we have to write logic for removing that.

		# 	content.each do |hotel|
		# 		hotel =JSON.parse(hotel)  #apply condition later based on manager 
		# 		all_hotels << hotel[hotel_name]
		# 	end
		# hotel_data.close

		@hotels = get_all_hotels # hotels in array

		prompt = TTY::Prompt.new
		selected_option = prompt.select("Please choose an option:", @@hotels)
		puts "You selected: #{selected_option}"

		#redirect manager on that hotel management method
		"#{selected_option}_management".call  #calling method
	end


	def create_rooms (hotel)
		prompt = TTY::Prompt.new
		choices = [
  		'standard',
  		'deluxe',
  		'suite'
		]
		selected_option = prompt.select("Please choose an option:", choices)
		puts "You selected: #{selected_option}"

		puts "Enter Price per night: "
		price_per_night = gets

		rooms_data=File.open("rooms.txt", "a+")

		#If we want to store data in array of hash than i think i have to 
		#take that approach like first users.txt -> content_var -> append userdata -> clean users.txt->
		#then save content_var in users.txt  || for cleaning data File.truncate(filename, 0)

		content = {"hotel_name"=>hotel,"room_type"=>selected_option, "price_per_night"=>price_per_night}
		rooms_data.syswrite(content)
		rooms_data.close
		puts "You have created room successfully."

		#redirect it to the previous hotel options
		{hotel}_management
	end


	def total_rooms (hotel)
		count = 0;

		rooms_data=File.open("rooms.txt", "r")
			content = File.read("rooms.txt").split("},{")
			#It has problem like first and last element of content
			#has [{ | }] . so we have to write logic for removing that.

			content.each do |room|
				room =JSON.parse(room)
				if(room[hotel_name] == hotel)
					count+=1
					puts "#{room[hotel_name]}    #{room[room_type]}    #{room[price_per_night]}"
				end
			end
			puts "Total Rooms: #{count}"
		user_data.close
	end


	# make metaprogramm from all hotels
	@hotels.each do |hotel|
		define_method("#{hotel}_management") do
      		#  pass hotel name when calling create room method

    	end
	end

end


m_m_o = ManagerMain.new

m_m_o.choices


