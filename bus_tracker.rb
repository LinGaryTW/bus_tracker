module Subscriber
  def update(publisher)
    raise 'Please use publisher information implement this method'
  end
end

module Publisher
  def initialize
    @subscribers = []
  end

  def regist_subscriber(subscriber)
    @subscribers << subscriber
  end

  def notify_subscribers(information)
    @subscribers.each do |subscriber|
      subscriber.update(information)
    end
  end
end

class Bus
  include Publisher

  attr_accessor :line, :status, :position
  def initialize
    super
    @position = 0
  end

  def leave
    @status = 'driving'
  end

  def arrive
    @status = 'stop'
    @position += 1
    notify_subscribers(@position)
  end
end

class Line
  include Publisher
  include Subscriber

  attr_reader :name, :start_location, :end_location, :stations, :buses
  def initialize(name, start_location, end_location, stations)
    @stations = stations
    @start_location = start_location
    @end_location = end_location
    @name = name
    @subscribers = @stations.each_with_object({}) { |station, result| result[station.name] = [] }
  end

  def regist_subscriber(user)
    @subscribers[user.target_station] << user
  end

  def summary
    { line: name, from: start_location, to: end_location }
  end

  def new_bus_start_serving_from(index, bus)
    bus.position = index
    bus.regist_subscriber(self)
  end

  def update(bus_position)
    users_need_to_be_notified(bus_position).each do |user|
      user.update(summary)
    end
  end

  private

  def users_need_to_be_notified(bus_position)
    if three_stations_less_from_ending_station(bus_position)
      remaining_users_sholud_be_notified(bus_position)
    else
      users_who_subscribe_spicific_station(bus_position)
    end
  end

  def users_who_subscribe_spicific_station(bus_position)
    @subscribers[@stations[bus_position + 3].name]
  end

  def three_stations_less_from_ending_station(bus_position)
    bus_position + 3 > @stations.length - 1
  end

  def remaining_users_sholud_be_notified(bus_position)
    users = []
    for i in (bus_position..@stations.length - 1)
      if !@subscribers[@stations[i].name].empty?
        @subscribers[@stations[i].name].each { |user| users << user }
      end
    end
    users
  end
end

class User
  include Subscriber
  attr_accessor :target_station

  def set_alert_for_target_station(line, station)
    self.target_station = station
    line.regist_subscriber(self)
  end

  def update(line_summary)
    print_notice(line_summary)
  end

  def print_notice(line_summary)
    p "#{line_summary[:line]} to #{line_summary[:to]} is coming to #{target_station}"
  end
end

class Station
  attr_reader :name
  def initialize(name)
    @name = name
  end
end
