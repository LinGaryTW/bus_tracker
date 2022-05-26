require './bus_tracker.rb'

stations = ["民生社區", "市民住宅", "國父紀念館",
            "捷運國父紀念館", "博仁醫院", "三民路", "大鵬新城"]
line672_to_Dapeng = Line.new('672', '民生社區', '大鵬新城', stations.map { |name| Station.new(name) })

gary = User.new('Gary')
alan = User.new('Alan')
scott = User.new('Scott')

p '目前有兩位旅客Gary, Alan 想在博仁醫院上車'
sleep 1

gary.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')
alan.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')

p 'Scott想要在三民路上車'
sleep 1

scott.set_alert_for_target_station(line672_to_Dapeng, '三民路')

p "672 往 大鵬新城 即將發車"
bus = Bus.new
line672_to_Dapeng.new_bus_start_serving_from(0, bus)

bus.leave
sleep 1

p "672 抵達市民住宅"

bus.arrive
sleep 1

p "672 即將前往國父紀念館"

bus.leave
sleep 1

p "672 抵達國父紀念館"

bus.arrive
