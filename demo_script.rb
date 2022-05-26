require './bus_tracker.rb'

stations = ["民生社區", "市民住宅", "國父紀念館",
            "捷運國父紀念館", "博仁醫院", "三民路", "大鵬新城"]
line672_to_Dapeng = Line.new('672', '民生社區', '大鵬新城', stations.map { |name| Station.new(name) })

gary = User.new('Gary')
alan = User.new('Alan')
scott = User.new('Scott')

puts '目前有兩位旅客Gary, Alan 想在博仁醫院上車 他們應該在公車抵達市民住宅時會收到通知'
sleep 2

gary.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')
alan.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')

puts 'Scott想要在三民路上車 他應該會在公車抵達國父紀念館時收到通知'
sleep 2

scott.set_alert_for_target_station(line672_to_Dapeng, '三民路')

puts "672 往 大鵬新城 發車囉！"
bus = Bus.new
line672_to_Dapeng.new_bus_start_serving_from(0, bus)
bus.leave

puts '.'
sleep 1
puts '.'
sleep 1
puts '.'
sleep 1

puts "672 抵達市民住宅"

bus.arrive
sleep 1

puts "672 即將前往國父紀念館"

bus.leave

sleep 1
puts '.'
sleep 1
puts '.'
sleep 1
puts '.'
sleep 1

puts "672 抵達國父紀念館"

bus.arrive
