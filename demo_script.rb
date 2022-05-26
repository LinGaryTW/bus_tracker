require './bus_tracker.rb'

stations = ["民生社區", "市民住宅", "國父紀念館",
            "捷運國父紀念館", "博仁醫院", "三民路", "大鵬新城"]
line672_to_Dapeng = Line.new('672', '民生社區', '大鵬新城', stations.map { |name| Station.new(name) })

stations = ["中正紀念堂", "總統府", "西門捷運站",
            "三重捷運站", "先嗇宮", "宜家傢俱", "新莊體育場"]
line235_to_Xinzhuang = Line.new('235', '台北市', '新莊', stations.map { |name| Station.new(name) })

gary = User.new('Gary')
alan = User.new('Alan')
scott = User.new('Scott')

puts '目前有兩位旅客Gary, Alan 想在博仁醫院上車 他們應該在公車抵達市民住宅時會收到通知'
sleep 2

gary.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')
alan.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')

puts 'Scott想要在三民路上車 他應該會在公車抵達國父紀念館時收到通知'
puts 'Scott 等等會轉車到235公車宜家傢俱站，並前往新莊體育場，如果235抵達西門捷運站他會收到通知'
sleep 4

scott.set_alert_for_target_station(line672_to_Dapeng, '三民路')
scott.set_alert_for_target_station(line235_to_Xinzhuang, '宜家傢俱')

puts "235 往 新莊 發車囉！"
bus_on_235 = Bus.new
line235_to_Xinzhuang.new_bus_start_serving_from(0, bus_on_235)
bus_on_235.leave

puts "672 往 大鵬新城 發車囉！"
bus_on_672 = Bus.new
line672_to_Dapeng.new_bus_start_serving_from(0, bus_on_672)
bus_on_672.leave

puts '.'
sleep 1
puts '.'
sleep 1
puts '.'
sleep 1

puts "672 抵達市民住宅"
puts "235 抵達總統府"

bus_on_235.arrive
bus_on_672.arrive
sleep 1

puts "672 即將前往國父紀念館"
puts "235 即將前往西門捷運站"

bus_on_235.leave
bus_on_672.leave

sleep 1
puts '.'
sleep 1
puts '.'
sleep 1
puts '.'
sleep 1

puts "672 抵達國父紀念館"
puts "235 抵達西門捷運站"
bus_on_235.arrive
bus_on_672.arrive
