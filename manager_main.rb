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


	def see_hotel
		all_hotels = []  #local var for storing hotels

		hotel_data=File.open("hotels.txt", "r")
			content = File.read("users.txt").split("},{")
			#It has problem like first and last element of content
			#has [{ | }] . so we have to write logic for removing that.

			content.each do |hotel|
				hotel =JSON.parse(hotel)
				all_hotels << hotel[hotel_name]
			end
		hotel_data.close
		prompt = TTY::Prompt.new
		selected_option = prompt.select("Please choose an option:", all_hotels)
		puts "You selected: #{selected_option}"

		

	end
end


m_m_o = ManagerMain.new

m_m_o.choices


