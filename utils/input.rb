class Input
  def initialize
    @count = 1
    # @main = Main.new
  end
  # main = Main.new

  def input_name
    begin
      puts 'Enter your name'
      name = gets.chomp.strip
      if(name == "")
        if(@count < 3)
          puts 'Please enter name first.'
          @count += 1
          raise
        elsif (@count == 3)
          puts 'You have reached maximum attempt.'
          Main.new.main
        end
      end
    rescue
      retry
    end
    return name
  end

  def input_email
    begin
      puts 'Enter your email'
      email = gets.chomp.strip.downcase
      result = Validation.new.email_validation(email)
      if(!result)
        if(@count < 3)
          puts 'Please enter a valid email address.'
          @count += 1
          raise
        elsif(@count == 3)
          puts 'You have reached maximum attempt.'
          Main.new.main
        end
      end
    rescue
      retry
    end
    return email
  end

  def input_password
    begin
      puts 'Enter your Password'
      password = gets.chomp.strip
      result = Validation.new.password_validation(password)
      if(!result)
        if(@count < 3)
          puts 'Password must have 6-8 characters long, one special character and a uppercase character.'
          @count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Main.new.main
        end
      end
    rescue
      retry
    end
    return password
  end

  def input_role
    begin
      puts 'Enter your Role(manager/customer)'
      role = gets.chomp.strip.downcase
      result = Validation.new.role_validation(role)
      if(!result)
        if(@count < 3)
          puts 'Please enter a valid role.(manager/customer)'
          @count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Main.new.main
        end
      end
    rescue
      retry
    end
    return role
  end

  def input_room_type(email, hotel_name)
    @count = 0
    begin
      puts 'Room Type (standard/deluxe/suite):'
      room_type = gets.chomp.strip.downcase

      if (room_type == "")
        if(@count < 2)
          puts 'Please enter room type first.'
          @count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(email).hotel_dashboard(hotel_name)
        end
      end

      if(!['standard', 'deluxe', 'suite'].include?(room_type))
        if(@count < 2)
          puts 'Please enter valid room type.'
          @count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(email).hotel_dashboard(hotel_name)
        end
      end
    rescue
      retry
    end
    return room_type
  end

  def input_price(email, hotel_name)
    @count = 0
    begin
      puts 'Price per night($):'
      price = gets.chomp.strip.to_i
      
      if((!price || price <= 0))
        if(@count < 2)
          puts 'Please enter valid price.'
          @count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(email).hotel_dashboard(hotel_name)
        end
      end
    rescue
      retry
    end
    price
  end

  def input_total_rooms(email, hotel_name)
    @count = 0
    begin
      puts 'Total rooms:'
      total = gets.chomp.strip.to_i
      
      if((!total || total <= 0))
        if(@count < 2)
          puts 'Please enter total rooms.'
          @count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(@email).hotel_dashboard(hotel_name)
        end
      end
    rescue
      retry
    end
    return total
  end

  def input_add_room(email, hotel_name)
    @count = 0
    begin
      puts 'Enter number of rooms to add:'
      add_count = gets.chomp.strip.to_i
      
      if((!add_count || add_count <= 0))
        if(@count < 2)
          puts 'Please enter valid room numbers.'
          @count += 1
          raise
        else
          puts 'You have reached maximum attempt.'
          Manager.new(email).hotel_dashboard(hotel_name)
        end
      end
    rescue
      retry
    end
    return add_count
  end

  def input_check_in(email)
    @count = 1
    while @count <= 3
      puts 'Enter Check-in Date (YYYY-MM-DD):'
      input = gets.chomp.strip

      begin
        check_in = Date.parse(input)
        break
      rescue
        puts 'Invalid date format.'
      end

      if @count == 3
        puts 'Maximum attempts reached.'
        Customer.new(email).menu
        return
      end
      @count += 1
    end
    return check_in
  end

  def input_check_out(email, check_in)
    @count = 1
    while @count <= 3
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

      if @count == 3
        puts 'Maximum attempts reached.'
        Customer.new(email).menu
        return
      end
      @count += 1
    end
    return check_out
  end

  def input_hotel_name(email)
    begin
      puts 'Enter Hotel name'
      hotel_name = gets.chomp.strip
      if(hotel_name == "")
        if(@count < 3)
        puts 'Please enter Hotel name first.'
        @count += 1
        raise
      elsif (@count == 3)
        puts 'You have reached maximum attempt.'
        Manager.new(email).menu
      end
    end
    rescue
      retry
    end
    return hotel_name
  end

  def input_location(email)
    begin
      puts 'Enter Location'
      location = gets.chomp.strip
      if(location == "")
        if(@count < 3)
          puts 'Please enter Location first.'
          @count += 1
          raise
        elsif (@count == 3)
          puts 'You have reached maximum attempt.'
          Manager.new(email).menu
        end
      end
    rescue
      retry
    end
    return location
  end
end