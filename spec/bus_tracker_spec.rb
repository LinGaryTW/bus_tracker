require './bus_tracker.rb'
# 【寫一個script,可以在672往大鵬新城方向的公車到達博仁醫院前3~5站時發出通知】
# 提示1:也要考慮系統同時有多人使用以及可以追蹤多條路線
# 提示2:語言/通知方法不限
describe "bus_tracker" do
  it 'send notification tree stations before arrival' do
    user1 = User.new
    user2 = User.new
    stations = make_stations(%w(民生社區 市民住宅 國父紀念館 捷運國父紀念館 博仁醫院 三民路))
    line672_to_Dapeng = Line.new('672', '民生社區', '大鵬新城')
    bus = Bus.new
    line672_to_Dapeng.new_bus_start_serving_from(bus, 0)
    user1.set_alert_three_stations_form_target_station(bus, '博仁醫院')
    user2.set_alert_three_stations_form_target_station(bus, '博仁醫院')
    bus.leave
    bus.arrive
    expect(user1.recieve_notice)
    expect(user2.recieve_notice)
  end

  it 'create new line' do
    stations = make_stations(%w(station1 station2 station3 station4))
    line = Line.new('1', 'start_location', 'end_location', stations)
    expect(line.summary).to_eq({ line: '1', from: 'start_location', to: 'end_location'})
    expect(line.stations).to be_a_kind_of(Array)
    expect(line.stations[0]).to be_a_kind_of(Station)
    expect(line.buses.size).to be(0)
  end
  
  it 'add bus to a line' do
    line = make_test_line_with_4_stations_no_bus
    bus = Bus.new
    line.new_bus_start_serving_from(bus, 0)
    expect(bus.line).to be(line)
    expect(line.buses).to be([bus])
  end
  
  it 'users set alert three stations form target station' do
    bus = Bus.new
    user1 = User.new
    user2 = User.new
    user1.set_alert_three_stations_form_target_station(bus, 3)
    user2.set_alert_three_stations_form_target_station(bus, 3)
    expect(bus.subscribers[3]).to eq([user1, user2])
  end

  it 'alert ringing when bus is three station form target station' do
    line = make_test_line_with_4_stations_no_bus
    bus = Bus.new
    line.new_bus_start_serving_from(bus, 0)
    user = User.new
    user.set_alert_three_stations_form_target_station(bus, 3)
    bus.leave
    bus.arrive
    expect(user.get_notice)
  end

  it 'create station' do
    station = Station.new('station1')
    expect(station.name).to be('station1')
  end

  it 'bus arrive station then leave' do
    bus = Bus.new
    bus.line = Line.new('1', 'start', 'end', [Station.new('s1'), Station.new('s1')])
    bus.position = 0
    bus.leave
    bus.arrive
  end
end

def make_test_line_with_4_stations_no_bus
end

def make_stations(station_names)
  station_names.map { |name| Station.new(name) }
end
