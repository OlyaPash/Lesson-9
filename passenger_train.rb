class PassengerTrain < Train
  
  validate :number, :presence
  validate :type, :presence
  validate :number, :format, /(.|\d){3}-*(.|\d){2}/

  def initialize(type = "passenger", number)
    @number = number
    @type = type
    super
  end

  def add_wagons(wagon)
    if type == wagon.type
      super
    else
      puts "К пассажирскому поезду нельзя прицеплять вагоны грузового типа!"
    end
  end
end
