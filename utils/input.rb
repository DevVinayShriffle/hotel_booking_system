class Input
  # @main = Main.new
  def initialize
    @count = 1
    @main = Main.new
  end

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
          @main.main
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
            @main.main
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
            @main.main
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
            @main.main
          end
        end
      rescue
        retry
      end
    return role
  end
end