require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
class Main
  def initialize
    @trains = {}
    @stations = []
    @routes = {}
  end

  def go
    loop do
      puts 'Выберите действие'
      puts '1 Действие с поездами'
      puts '2 Действие со станциями'
      puts '3 Действие с  маршрутами'
      id = gets.chomp.to_i
      case id
      when 1 then trains_menu
      when 2 then station_menu
      when 3 then routes_menu

      else
        exit
      end
    end
  end

  private # юзер работает онли через метод go
  def train_name(train)

    puts "Данный поезд принадлежит компании #{train.view_comp_name}"
  end

  def add_name(train)
    puts 'Введите Название компании'
    name = gets.chomp.to_s
    train.add_name(name)
  end

  def next_station(train)
    train.next_station
  rescue RuntimeError => e
    puts e.message.to_s
  end

  def prev_station(train)

    train.prev_station
  rescue RuntimeError => e
    puts e.message.to_s

  end

  def stations_list
    if @stations.any?
      @stations.each_with_index do |value, index|
        puts "id = #{index}  --- #{value.name} на станции находятся поезда: #{value.trains}"
      end
    else
      puts 'Станций нет!'
    end
  end

  def remove_station(route)
    puts 'Выберите станцию'
    puts route.list

    stations_id = gets.chomp.to_i
    route.remove_station(@stations[stations_id])
  end

  def add_station(route)
    puts 'Выберите станцию'
    stations_list
    stations_id = gets.chomp.to_i
    route.add_station(@stations[stations_id], stations_id)

  end

  def create_route
    puts 'Введите id станций,минимум две станции через запятую'
    stations_list
    stations_ids = gets.chomp.split(',')
    names = []
    @stations.each_with_index do |value, index|
      stations_ids.each do |values|
        names << value if index == values.to_i
      end
    end
    stations_ids = stations_ids.join('')
    @routes[stations_ids] = Route.new(names)
  rescue RuntimeError => e
    puts e.message.to_s
    retry
  end

  def route_menu(route)
    loop do
      puts "1 Добавить станцию в маршруте #{route} "
      puts "2 Удалить станцию в маршруте #{route} "
      act = gets.chomp.to_i
      case act
      when 1 then add_station(route)
      when 2 then remove_station(route)
      else
        break
      end
    end
  end

  def routes_menu
    if @stations.count > 1
      loop do
        puts 'Введите желаемое действие'
        puts '1 Создать маршрут'
        puts '2 Выбрать маршрут'

        id = gets.chomp.to_i
        case id
        when 1 then create_route
        when 2
          if @routes.any?
            route_list
            route = gets.chomp.to_s
            route_menu(@routes[route])
          else
            'Маршрутов нет'
          end
        else
          break
        end
      end
    else
      puts 'Для создания маршрута нужно минимум две станции'
    end
  end

  def create_station
    begin
    puts 'Введите название станции'
    name = gets.chomp.to_s
    @stations << Station.new(name)

    rescue RuntimeError => e
      puts e.message.to_s
      retry
  end
    puts "Станция #{name} Создана"

  end

  def station_menu
    loop do
      puts '1 Cоздать станцию'
      puts '2 Список  станций'
      act = gets.chomp.to_i
      case act
      when 1 then create_station
      when 2 then stations_list
      else
        break
      end
    end
    end

  def route_list
    @routes.each do |index, value|
      puts " id #{index} #{value.stations}"
    end
  end

  def add_route(train)
    puts "Выбран поезд #{train}"
    puts 'Введите номер маршрута'
    route_list
    route_name = gets.chomp.to_s
    raise 'Нет такого маршрута' unless @routes[route_name]

    route_value = @routes[route_name]
    @trains[train.number].add_route(route_value)
  rescue RuntimeError => e
    puts e.message.to_s
    retry
  end

  def create_cargo_train(train_number)
    @trains[train_number] = CargoTrain.new(train_number)
    puts "Поезд #{train_number} Создан"
  end

  def create_passenger_train(train_number)
    @trains[train_number] = PassengerTrain.new(train_number)
    puts "Поезд #{train_number} Создан"
  end

  def trains_list
    @trains.each do |name, value|
      puts "Поезд номер = #{name} Тип #{value.train_type}"
    end
  end

  def create_train
    loop do
      puts 'Какой поезд создать: 1 -- Грузовой, 2 -- Пасажирский'
      train_type = gets.chomp.to_i
      case train_type
      when 1
        puts 'Введите номер поезда'
        train_number = gets.chomp.to_s
        create_cargo_train(train_number)

      when 2
        puts 'Введите номер поезда'
        train_number = gets.chomp.to_s
        create_passenger_train(train_number)
      else
        break
      end
    end
  rescue RuntimeError => e
    puts e.message.to_s
    retry
  end

  def remove_wagons(train)
    train.remove_wagon
  end

  def add_wagons(train)

    puts "Ваш поезд #{train.type} типа"
    puts 'Какой вагон Присоеденить'
    puts '1 - Пасажирский '
    puts '2 - Грузовой'

    wagon_type = gets.chomp.to_i
    wagon = if wagon_type == 1
              PassengerWagon.new
            else
              CargoWagon.new
            end

    puts wagon
    train.add_wagon(wagon)
  rescue RuntimeError => e
    puts e.message.to_s
    retry

  end

  def train_menu(train)
    raise 'Такого поезда не существует' unless @trains.value? train

    loop do
      puts "Выбран поезд #{train.number}"
      puts '1 Добавить вагон'
      puts '2 Удалить вагон'
      puts '3 Добавить Маршрут'
      puts '4 Вперед по маршруту'
      puts '5 Назад по маршруту'
      puts '6 Назначить название компании изготовителя'
      puts '7 Имя производителя поезда'
      act = gets.chomp.to_i
      case act
      when 1 then  add_wagons(train)
      when 2 then  remove_wagons(train)
      when 3 then add_route(train)
      when 4 then next_station(train)
      when 5 then prev_station(train)
      when 6 then add_name(train)
      when 7 then train_name(train)
      else
        break
      end

    end

  end

  def trains_menu
    loop do
      puts '1 Выбрать поезд'
      puts '2 Создать поезд'
      case gets.chomp.to_i
      when 1
        if @trains.any?
          begin
              puts 'Выберите поезд'
              trains_list
              train = gets.chomp.to_s
              train_menu(@trains[train])
          rescue RuntimeError => e
            puts e.message.to_s
            retry
            end
        else
          puts 'Поездов нет'

        end
      when 2
        create_train

      else
        break
      end
    end

  end

end
Main.new.go

