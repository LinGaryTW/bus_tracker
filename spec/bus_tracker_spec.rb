require './bus_tracker.rb'

describe "bus_tracker" do
  it 'send notification tree stations before arrival' do
    user1 = User.new
    user2 = User.new
    stations = make_stations(%w(民生社區 市民住宅 國父紀念館 捷運國父紀念館 博仁醫院 三民路))
    line672_to_Dapeng = Line.new('672', '民生社區', '大鵬新城', stations)
    bus = Bus.new
    line672_to_Dapeng.new_bus_start_serving_from(0, bus)
    user1.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')
    user2.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')
    expect(user1).to receive(:print_notice).with(line672_to_Dapeng.summary)
    expect(user2).to receive(:print_notice).with(line672_to_Dapeng.summary)
    bus.leave
    bus.arrive
  end
end

describe 'line' do
  before do
    @line = make_test_line_with_4_stations_no_bus
  end

  it 'create station' do
    station = Station.new('station1')
    expect(station.name).to eq('station1')
  end

  it 'create new line' do
    expect(@line.summary).to eq({ line: '1', from: 'start_location', to: 'end_location'})
    expect(@line.stations).to be_a_kind_of(Array)
    expect(@line.stations[0]).to be_a_kind_of(Station)
    expect(@line.instance_variable_get(:@subscribers)['station1']).to eq([])
  end
  
  it 'add bus to a line' do
    bus = Bus.new
    @line.new_bus_start_serving_from(1, bus)
    expect(bus.instance_variable_get(:@subscribers)).to eq([@line])
    expect(bus.position).to be(1)
  end

  it 'update information to notify users' do
    user = User.new
    user.target_station = 'station3'
    @line.regist_subscriber(user)
    expect(user).to receive(:update)
    @line.update(1)
    expect(@line.instance_variable_get(:@subscribers)['station3']).to eq([])
  end

  it 'remaining stations sholud be notified' do
    expect(@line.send(:remaining_stations_sholud_be_notified, 1)).to eq(['station2', 'station3', 'station4'])
  end

  it 'spicific station' do
    expect(@line.send(:spicific_station, 0)).to eq(['station4'])
  end

  it 'only three stations from ending station' do
    expect(@line.send(:three_stations_less_from_ending_station, 1)).to be(true)
    expect(@line.send(:three_stations_less_from_ending_station, 0)).to be(false)
  end
end

describe 'bus' do 
  before do
    @bus = Bus.new
  end

  it 'bus leave station then arrive' do
    @bus.leave
    expect(@bus.status).to eq('driving')
    @bus.arrive
    expect(@bus.status).to eq('stop')
    expect(@bus.position).to be(1)
  end

  it 'bus notify subscribers' do
    line = make_test_line_with_4_stations_no_bus
    line.new_bus_start_serving_from(0, @bus)
    expect(line).to receive(:update).with(@bus.position)
    @bus.notify_subscribers(@bus.position)
  end
end
  
describe 'user' do
  it 'users set target station alert' do
    line = make_test_line_with_4_stations_no_bus
    bus = Bus.new
    user1 = User.new
    user2 = User.new
    user1.set_alert_for_target_station(line, 'station1')
    user2.set_alert_for_target_station(line, 'station2')
    line_subscribers = line.instance_variable_get(:@subscribers)
    expect(line_subscribers).to eq({ 'station1' => [user1], 'station2' => [user2],
                                     'station3' => [], 'station4' => [] })
    expect(user1.target_station).to eq('station1')
    expect(user2.target_station).to eq('station2')
  end
  
  it "print line summary" do
    user = User.new
    user.target_station = '國父紀念館'
    summary = { line: '679', from: '民生社區', to: '大鵬新城' }
    expect(user).to receive(:p).with("679 to 大鵬新城 is coming to 國父紀念館")
    user.print_notice(summary)
  end
end

def make_test_line_with_4_stations_no_bus
  stations = make_stations(%w(station1 station2 station3 station4))
  Line.new('1', 'start_location', 'end_location', stations)
end

def make_stations(station_names)
  station_names.map { |name| Station.new(name) }
end
