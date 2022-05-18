class CargoTrain < Train
  validate :number, :presence
  validate :type, :presence

  def initialize(type = "cargo", number)
    @number = number
    @type = type
    super
  end

  def add_wagons(wagon)
    if type == wagon.type
      super
    else
      puts "К грузовому поезду нельзя прицеплять вагоны пассажирского типа!"
    end
  end
end
