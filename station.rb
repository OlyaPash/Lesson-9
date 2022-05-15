require_relative 'instance_counter'

class Station
  include InstanceCounter
  @@stations = []

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    validate!
    puts "Станция #{name} построена."
    @@stations << self
    register_instance
  end

  def self.all
    @@stations
  end

  def get_train(train)
    @trains << train
    puts "Уважаемые пассажиры! На станцию #{name} прибыл поезд № #{train.number}"
  end

  def show_trains(type = nil)
    if type
      puts "На станции #{name} поездa типа #{type} №:"
      trains.each { |train| puts train.number if train.type == type }
    else
      puts "На станции #{name} поезда №: "
      trains.each { |train| puts train.number }
    end
  end

  def send_train(train)
    trains.each(&:number) # { |train| train.number }
    trains.delete(train)
    puts "Поезд №#{train.number} отправляется со станции #{name}"
  end

  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end

  def block_trains(&block)
    @trains.each(&block)
  end

  protected

  def validate!
    raise ArgumentError, "Название станции не указано!" if @name.empty?
  end
end
