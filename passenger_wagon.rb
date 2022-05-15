require_relative 'company'

class PassengerWagon < Wagon
  include Company

  def initialize(type = "passenger", total_place)
    super
  end

  def take_seat
    @used_place += 1 if free_place.positive?
  end
end
