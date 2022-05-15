require_relative 'company'

class CargoWagon < Wagon
  include Company

  def initialize(type = "cargo", total_place)
    super
  end

  def received_volume(volume)
    @used_place += volume if free_place >= volume
  end
end
