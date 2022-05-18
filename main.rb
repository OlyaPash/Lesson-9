class Main
  attr_accessor :stations, :trains, :routes, :wagons, :end_station, :starting_station

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
    # @end_station = end_station
    # @starting_station = starting_station
  end

  def create_station
    puts "Введите назание станции: "
    st_name = gets.chomp
    station = Station.new(st_name)
    @stations << station
    @stations.each { |el| puts el.name }
    # rescue ArgumentError => e
    #   puts "Ошибка: #{e}"
    #   retry
  end

  def create_train
    puts "Введите номер для нового поезда:"
    number = gets.chomp # .to_i
    puts "Выберите тип поезда: passenger, cargo"
    type = gets.chomp
    raise StandardError, "Неправильный тип поезда" unless %w[cargo passenger].include?(type)

    case type
    when "passenger"
      train = PassengerTrain.new(number, type)
      @trains << train
    when "cargo"
      train = CargoTrain.new(number, type)
      @trains << train
    end

    puts "Создан поезд №#{number}, тип: #{type}"
    # rescue ArgumentError => e
    #   puts "Ошибка формата: #{e}"
    #   retry
  rescue StandardError => e
    puts "Ошибка: #{e}"
  end

  def create_route
    # if @stations.length < 2
    # puts "В маршруте должно быть минимум две станции!"
    # else
    stations_list
    puts "Введите индекс станции, чтобы выбрать начальную: "
    @starting_station = gets.chomp.to_i
    first_st = @stations[@starting_station]
    puts "Введите индекс для конечной: "
    @end_station = gets.chomp.to_i
    last_st = @stations[@end_station]
    route = Route.new(first_st, last_st)
    @routes << route
    # end
  rescue StandardError => e
    puts "Ошибка: #{e}"
  end

  def add_station_route
    if @routes.empty?
      puts "Маршрут пуст!"
    else
      @routes.each_with_index do |v, i|
        puts "#{i} : #{v.stations.first.name} - #{v.stations.last.name}"
      end
      puts "Выберите маршрут(индекс): "
      route = gets.to_i

      @routes[route].show_stations
      puts "Выберите станцию(индекс), чтобы добавить к маршруту: "
      @stations.each_with_index { |v, i| puts "#{i} - #{v.name}" }
      st_name = gets.chomp.to_i
      @routes[route].add_station(@stations[st_name])
      @routes[route].show_stations
    end
  end

  def remove_station
    if @routes.empty?
      puts "Маршрут пуст!"
    else
      @routes.each_with_index do |v, i|
        puts "#{i} : #{v.stations.first.name} - #{v.stations.last.name}"
      end
      puts "Выберите маршрут: "
      route = gets.to_i

      @routes[route].show_stations
      puts "Выберите станцию(индекс), чтобы удалить из маршрута: "
      @stations.each_with_index { |v, i| puts "#{i} - #{v.name}" }
      st_name = gets.chomp.to_i
      @routes[route].delete_station(@stations[st_name])
      @routes[route].show_stations
    end
  end

  def route_get
    if @routes.empty?
      puts "В маршруте нет станций! Нужно добавить станции!"
    else
      @trains.each_with_index { |v, i| puts "Индекс:#{i} - №#{v.number}" }
      puts "Введите индекс номера поезда, которому хотите назначить маршрут: "
      train = gets.chomp.to_i

      @routes.each_with_index do |v, i|
        puts "#{i} : #{v.stations.first.name} - #{v.stations.last.name}"
      end

      puts "Выберите маршрут: "
      route = gets.to_i

      @trains[train].received_route(@routes[route])
    end
  end

  def add_wagon_train
    if @trains.empty?
      puts "Необходимо создать поезд!"
    else
      trains_list
      puts "Введите индекс поезда которому хотите добавить вагон: "
      train = gets.to_i

      case @trains[train].type
      when "cargo"
        puts "Укажите общий объем:"
        total_place = gets.chomp.to_i
        wagon = CargoWagon.new(total_place)
        @wagons << wagon
        @trains[train].add_wagons(wagon)
      when "passenger"
        puts "Укажите количество мест в вагоне:"
        total_place = gets.chomp.to_i
        wagon = PassengerWagon.new(total_place)
        @wagons << wagon
        @trains[train].add_wagons(wagon)
      end

    end
  end

  def delete_wagon
    if @trains.empty?
      puts "Необходимо создать поезд!"
    else
      trains_list
      puts "Введите индекс поезда от которого хотите отцепить вагон: "
      train = gets.to_i

      @trains[train].remove_wagons
    end
  end

  def info_wagons
    trains_list
    puts "Введите индекс поезда:"
    train = gets.to_i

    return unless @trains[train].wagons.any?

    puts "Выберите вагон:"
    num = 1
    @trains[train].wagons_list do |wagon|
      if wagon.instance_of?(PassengerWagon)
        puts "Вагон №#{num}. Занятых мест: #{@used_place.to_i}, свободных: #{wagon.free_place}"
      else
        puts "Вагон №#{num}. Занятый объем: #{@used_place.to_i}, свободно: #{wagon.free_place}"
      end
      num += 1

      choise = gets.to_i
      wagon = @trains[train].wagons[choise - 1]

      if wagon.instance_of?(CargoWagon)
        puts "Введите объем груза:"
        volume = gets.to_i
        puts "Занято: #{wagon.received_volume(volume)}, свободно: #{wagon.free_place}"
      else
        puts "Занято мест: #{wagon.take_seat}, свободно: #{wagon.free_place}"
      end
    end
  end

  def train_next
    if @trains.empty?
      puts "Необходимо создать поезд!"
    else
      trains_list
      puts "Введите индекс поезда: "
      train = gets.chomp.to_i
      @trains[train].moving_next
    end
    @trains[train].pre_curr_next
  end

  def train_back
    if @trains.empty?
      puts "Необходимо создать поезд!"
    else
      trains_list
      puts "Введите индекс поезда: "
      train = gets.chomp.to_i
      @trains[train].moving_back
    end
    @trains[train].pre_curr_next
  end

  def trains_on_station
    @stations.each do |station|
      puts "На станции #{station.name} поезда:"
      # station.trains.each do |train|
      station.block_trains do |train|
        puts "Поезд №#{train.number} типа: #{train.type}, количество вагонов: #{train.wagons.size}"
        # puts "№#{train.number}"
      end
    end
  end

  def stations_list
    @stations.each_with_index do |station, index|
      puts "Индекс: #{index} станция: #{station.name}"
    end
  end

  def trains_list
    @trains.each_with_index do |train, index|
      puts "В списке с индексом: #{index} поезд №#{train.number}"
    end
  end

  def show_station_train_list
    stations_list
    trains_list
  end

  def to_begin
    loop do
      puts
      puts "Введите номер для: "
      puts "1. Создания станции"
      puts "2. Создания поезда"
      puts "3. Создания маршрута"
      puts "4. Добавления станции"
      puts "5. Удаления станции из маршрута"
      puts "6. Назначения маршрута поезду"
      puts "7. Добавления вагонов к поезду"
      puts "8. Отцепки вагонов от поезда"
      puts "9. Перемещения поезда по маршруту вперед "
      puts "10.Перемещения поезда назад"
      puts "11.Просматривания списка станций и списка поездов на станции"
      puts "12.Вагоны"
      puts "0. Выход"

      run(gets.chomp)
      # break puts "До свидания!" if input.zero?
    end
  end

  def run(key)
    actions = {
      '1' => :create_station, '2' => :create_train,
      '3' => :create_route, '4' => :add_station_route,
      '5' => :remove_station, '6' => :route_get,
      '7' => :add_wagon_train, '8' => :delete_wagon,
      '9' => :train_next, '10' => :train_back,
      '11' => :trains_on_station, '12' => :info_wagons,
      '0' => :bye
    }
    if actions.key?(key)
      send(actions[key])
    else
      puts "Такого действия нет :)"
      puts "Выберите из списка >>"
    end
  end

  def bye
    puts "До свидания!"
    abort
  end
end
