module CustomerFileModule
  HOTELS_FILE   = 'data/hotels.txt'
  ROOMS_FILE    = 'data/rooms.txt'
  BOOKINGS_FILE = 'data/bookings.txt'

  def read_file(file)
    data = []
    begin
      if File.exist?(file)
        File.open(file, 'r') do |f|
          f.each_line { |line| data << line.strip }
        end
      end
    rescue
      puts "Unable to read file."
      return
    end
    data
  end

  def write_all(file, lines)
    begin
      File.open(file, 'w') do |f|
        lines.each { |line| f.puts(line) }
      end
    rescue
      puts "Unable to update file."
      return
    end
  end

  def append_file(file, line)
    begin
      File.open(file, 'a') { |f| f.puts(line) }
    rescue
      puts "Unable to append file."
      return
    end
  end
end
