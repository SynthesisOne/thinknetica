require_relative 'modules/company_name'
require_relative 'modules/instance_counter'
class Train
  include CompanyName
  include InstanceCounter
  attr_reader :number, :type
  attr_accessor :speed, :route, :current, :train_type, :wagons
  NUMBER_FORMAT = /^[а-яa-z0-9]{3}-?[а-яa-z0-9]{2}$/i.freeze
  @@trains = {}
  def initialize(number)
    @speed = 0
    @number = number
    @wagons = []
    @@trains[number] = self
    validate!
  end

  def self.find(number)
    @@trains[number]
  end

  def validate!
    raise 'Номер отсутствует' if @number.nil?
    raise 'Неверная длина номера' if @number.length < 4 || @number.length > 7
    raise 'Номер не соответствует формату' unless @number =~ NUMBER_FORMAT

  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def cargo?
    type == 'cargo'
  end

  def passenger?
    type == 'passenger'
  end

  def remove_wagon
    wagons.delete(-1) unless wagons.empty?
  end

  def add_wagon(wagon)
    if wagon.wagon_type == train_type
      wagons << wagon

      puts "Вагон #{wagon} прицеплен"
    else
      raise 'Приципите вагон правильного типа'
    end
  end

  def add_route(route)
    @route = route
    @current = route.stations.first
    route.stations.first.add_train(self)
    puts "Поезд №#{@number} готов ехать с станции #{@route.stations.first.name} на станцию #{@route.stations.last.name}"

  end

  def prev_station
    raise 'У поезда нет маршрута' unless @route

    if @current != @route.stations.first
      prev_step = @route.stations.index(@current) - 1
      @current = @route.stations[ prev_step]
      route.stations[prev_step].add_train(self)
    else
      raise 'Станция конечная'
    end

  end

  def next_station
    raise 'У поезда нет маршрута' unless @route

    if @current != @route.stations.last
      next_step = @route.stations.index(@current) + 1
      @current = @route.stations[next_step]
      route.stations[next_step].add_train(self)
    else
      raise 'Станция конечная'
    end

  end

  def add_speed(speed)
    self.speed += speed.to_i
  end

  def stop_train
    if self.speed <= 0
      raise 'Поезд уже остановлен'
    else
      self.speed = 0
      puts 'Поезд остановлен'
    end
  end
end
