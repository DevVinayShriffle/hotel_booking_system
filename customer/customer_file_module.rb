module CustomerFileModule
  HOTELS_FILE   = 'data/hotels.txt'
  ROOMS_FILE    = 'data/rooms.txt'
  BOOKINGS_FILE = 'data/bookings.txt'

  def read_file(file)
    data = []
    if File.exist?(file)
      File.open(file, 'r') do |f|
        f.each_line { |line| data << line.strip }
      end
    end
    data
  end

  def write_all(file, lines)
    File.open(file, 'w') do |f|
      lines.each { |line| f.puts(line) }
    end
  end

  def append_file(file, line)
    File.open(file, 'a') { |f| f.puts(line) }
  end
end
