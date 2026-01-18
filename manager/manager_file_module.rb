module ManagerFileModule
  HOTELS_FILE = 'data/hotels.txt'
  ROOMS_FILE = 'data/rooms.txt'
  BookingS_FILE = 'data/bookings.txt'

  def read_file(file)
    data = []
    begin
      if File.exist?(file)
        File.open(file, 'r') do |f|
          IO.foreach(f) {|line| data << line}
        end
      end
    rescue
      puts "Unable to read file."
      return
    end
    data
  end

  def append_file(file, data)
    begin
      File.open(file, 'a'){|f| f.puts(data)}
    rescue
      puts "Unable to append file."
      return
    end
  end
end