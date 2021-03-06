class Station
  attr_reader :name
  attr_accessor :trains
  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train if train.route.stations.include?(self)

    puts "На  станцию #{@name} Прибыл поезд поезд под номером #{train.number}"
  end

  def send_train(train)
    @trains.delete(train)

    puts "Со станции #{@name} отправлен поезд под номером #{train.number}"
  end

  def train_type
    [@trains.count(&:cargo?), @trains.count(&:passenger?)]

  end

  # def train_type
  #   cargo = 0
  #   passenger = 0
  #   @train.each do |train|
  #     cargo += 1 if train.type == 'cargo'
  #     passenger += 1 if train.type == 'passenger'
  #   end
  #   [cargo, passenger]
  # end

  end

class Train
  attr_reader :type, :number
  attr_accessor :speed, :count, :route, :current
  def initialize(number, type, count)
    @speed = 0
    @number = number
    @type = type
    @count = count
  end
  [:cargo, :passenger].each do |m_type|
    define_method "#{m_type}?" do
      type == m_type.to_s
      type == m_type.to_s
    end
  end
  # def cargo?
  #   true if type == 'cargo'
  # end
  #
  # def passenger?
  #   true if type == 'passenger'
  # end

  def add_wagon
    if count > 0
      self.count -= 1
      puts "Вагон отцеплен, осталось #{count} вагонов"
    else
      puts 'Вагонов не осталось'
    end
  end

  def add_route(route)
    @route = route
    @current = route.stations.first
    route.stations.first.add_train(self)
    puts "Поезд №#{@number} готов ехать с станции #{@route.stations.first.name} на станцию #{@route.stations.last.name}"

  end

  def prev
    if @current != @route.first
      prev_step = @route.stations.index(@current) - 1
      @current = @route.stations[ prev_step]
      route.stations[prev_step].add_train(self)
    else
      puts 'Станция конечная'
    end
  end

  def next

    if @current != @route.last
      next_step = @route.stations.index(@current) + 1
      @current = @route.stations[next_step]
      route.stations[next_step].add_train(self)
    else
      puts 'Станция конечная'
    end
  end

  def add_speed(speed)
    self.speed += speed.to_i
  end

  def stop_train
    if self.speed <= 0
      puts 'Поезд уже остановлен'
    else
      self.speed = 0
      puts 'Поезд остановлен'
    end
  end
  end

class Route
  attr_accessor :stations
  def initialize(stations = [])
    if stations.size >= 2
      @stations = stations
      puts "Маршрут #{@stations.first.name} - #{@stations.last.name} создан"

    else
      puts 'Должна быть начальная и конечная станция!'
  end
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def remove_station(station)
    stations.delete(station)
  end

  def list
    stations
  end


end
