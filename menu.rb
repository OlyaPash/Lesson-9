require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'accessors'
require_relative 'validation'
require_relative 'main'
require_relative 'company'
require_relative 'instance_counter'

interface = Main.new
interface.to_begin

# wagon2 = CargoWagon.new(30)
# puts wagon2.volume
# wagon2.filling(10)
# wagon2.available_volume

# wagon1 = PassengerWagon.new(33)
# wagon1.free_seat
# wagon1.take_seat
# wagon1.take_seat
# wagon1.occupied_seat
# wagon1.free_seat

# train1 = Train.new("234-gt", "cargo")
# train2 = Train.new("345hg", "passenger")
# train1.company_name = "Happy Train"

# puts train1.valid?

# puts train1.company_name

# station1 = Station.new("Sochi")
# station2 = Station.new("Adler")

# route = Route.new(station1, station2)

# puts Station.all

# puts Train.find("234-gt")

# puts Station.instances
# puts Train.instances
# puts Route.instances
