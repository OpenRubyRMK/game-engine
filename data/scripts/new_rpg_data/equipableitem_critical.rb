require_relative "battler_equipment"
require_relative "battler_critical"
require_relative "battler_state"
module RPG
	module EquipableItem
		attr_reader :critical_stats,:critical_states
		private
		def critical_cs_init_equipable
			@critical_stats = {}
			@critical_stats.default = 0
			
			@critical_states = []
		end
		
		def critical_cs_to_xml_equipable(xml)
			xml.critical {
				xml.stats {
					@critical_stats.each {|name,v| xml.stat(v,:name=>name)}
				}
				xml.states {
					@critical_states.each {|name| xml.state(:name=>name)}
				}
			}
		end
		def critical_cs_parse_equipable(item)
			item.xpath("critical/stats/stat").each {|node|
				@critical_stats[node[:name].to_sym] = node.text.to_f
			}
			item.xpath("critical/states/state").each {|node|
				@critical_states << node[:name].to_sym
			}
		end
	end
end

module Game
	module EquipableItem
		attr_reader :critical_states
		private
		def critical_cs_init
			@critical_states = {}
			rpg.critical_states.each{|n| @critical_states[n] = State.new(n) }
		end
	end
	class Battler
		private
		def equipment_critical_cs_stat_add(stat)
			return 0 unless critical
			return equips.values.map{|item| item.rpg.critical_stats[stat]}.inject(0,&:+)
		end
		def equipment_critical_cs_states
			temp = Hash.new([])
			equips.each_value{|i|i.critical_states.each {|k,v| temp[k] += [v]} } if critical
			return temp
		end
	end
end
