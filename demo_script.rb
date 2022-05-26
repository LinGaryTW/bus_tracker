require 'bus_tracker.rb'

stations = ["民生社區", "市民住宅", "國父紀念館", "捷運國父紀念館", "博仁醫院", "三民路"].map { |name| Station.new(name) }
user1 = User.new
user2 = User.new
line672_to_Dapeng = Line.new('672', '民生社區', '大鵬新城', stations)
bus = Bus.new
line672_to_Dapeng.new_bus_start_serving_from(0, bus)
user1.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')
user2.set_alert_for_target_station(line672_to_Dapeng, '博仁醫院')
