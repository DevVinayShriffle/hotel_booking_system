module ManagerFileModule
    HOTELS_FILE = 'data/hotels.txt'
    ROOMS_FILE = 'data/rooms.txt'
    BookingS_FILE = 'data/bookings.txt'

    def read_file(file)
        data = []
        if File.exist?(file)
            File.open(file, 'r') do |f|
                IO.foreach(f) {|line| data << line}
            end
        end
        data
    end

    def append_file(file, data)
        File.open(file, 'a'){|f| f.puts(data)}
    end

end