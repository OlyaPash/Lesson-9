require_relative 'company'
require_relative 'instance_counter'

class Train
  include Company
  include InstanceCounter
  @@trains = []

  attr_accessor :speed, :number, :station, :route, :wagons, :type
  attr_writer :station_index

  # три буквы или цифры в любом порядке, необязательный дефис (может быть, а может нет)
  # и еще 2 буквы или цифры после дефиса

  NUMBER_FORMAT = /(.|\d){3}-*(.|\d){2}/

  def initialize(number, type, speed = 0)
    @speed = speed
    @number = number
    @type = type
    @wagons = []
    @station_index = 0
    validate!
    # puts "Создан поезд №#{number}, тип: #{type}"
    @@trains << self
    register_instance
  end

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def add_wagons(wagon)
    if speed.zero? && @type == wagon.type
      wagons << wagon
      puts "Прицеплен 1 вагон типа #{wagon.type}."
    else
      puts "Поезд находится в движении, невозможно прицеплять вагоны!"
    end
  end

  def remove_wagons
    if wagons.empty?
      puts "Все вагоны уже были отцеплены!"
    elsif speed.zero?
      @wagons.pop
      puts "Отцеплен 1 вагон"
    else
      puts "Нельзя на ходу отцеплять вагоны!"
    end
  end

  def received_route(route)
    self.route = route
    print "Поезду № #{number} типа #{type} "
    puts "назначен маршрут #{route.stations.first.name} - #{route.stations.last.name}"
    route.stations.first.get_train(self)
  end

  def current_station
    @route.stations[@station_index]
  end

  def moving_next
    if @route.stations[@station_index + 1]
      current_station.send_train(self)
      @station_index += 1
      current_station.get_train(self)
    else
      puts "Впереди нет станций!"
    end
  end

  def moving_back
    if @station_index.positive?
      current_station.send_train(self)
      @station_index -= 1
      current_station.get_train(self)
    else
      puts "Позади нет станций!"
    end
  end

  def pre_curr_next
    puts "Текущая станция поезда #{route.stations[@station_index].name}"
    puts "Следующая - #{route.stations[@station_index + 1].name}" if @station_index != route.stations.size - 1
    puts "Предыдущая - #{route.stations[@station_index - 1].name}" if @station_index.positive?
  end

  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end

  def wagons_list
    @wagons.each_with_index { |wagon, _index| yield wagon }
  end

  protected

  def validate!
    raise ArgumentError, "Номер поезда не указан!" if @number.empty?
    raise ArgumentError, "Номер поезда должен быть в формате ххх-хх или ххххх!" if @number !~ NUMBER_FORMAT
  end

  private # методы доступные классу

  def current_speed
    speed
  end

  def stop
    self.speed = 0
  end
end
