=begin
	File equipmentitem_states.rb

	used cs:
	RPG::EquipableItem
		cs_init_equipable
		cs_to_xml_equipable
		cs_parse_equipable
	Game::EquipableItem
		cs_init
	Game::Battler
		cs_can_equip
		cs_remove_state
		cs_states
		cs_states_chance
=end

require_relative "battler_equipment"
require_relative "battler_state"

module RPG
	module EquipableItem
		attr_accessor :state_chance,:auto_states,:require_states
		private
		def states_cs_init_equipable
			@auto_states = []
			@require_states = []
			@state_chance = Hash.new(1.0)
		end
		def states_cs_to_xml_equipable(xml)
			xml.state_chance{
				@state_chance.each{|n,v| xml.state(v,:name=>n) }
			}
			xml.require_states{
				@require_states.each{|n| xml.state(:name=>n)}
			}
			xml.auto_states{
				@auto_states.each{|n| xml.state(:name=>n)}
			}
		end
		def states_cs_parse_equipable(item)
			item.xpath("state_chance/state").each {|node|
				@state_chance[node[:name].to_sym] = node.text.to_f
			}
			item.xpath("require_states/state").each {|node|
				auto_states << node[:name].to_sym
				State.parse_xml(node) unless node.children.empty?
			}
		
			item.xpath("auto_states/state").each {|node|
				auto_states << node[:name].to_sym
				State.parse_xml(node) unless node.children.empty?
			}
		end
	end
end

module Game
	module EquipableItem
		attr_reader :auto_states
		private
		def autostates_cs_init
			@auto_states = {}
			rpg.auto_states.each{|n| @auto_states[n] = State.new(n) }
		end
	end
	class Battler
		private
		def states_cs_can_equip(key,item)
			return RPG::BaseItem[item].require_states.all? {|k|
				!states[k].empty?
			}
		end
		def equipment_cs_remove_state(state)
			equips.each{|k,v|
				if v.rpg.require_states.include?(state)
					equip(k,nil) unless can_equip?(k,v.rpg.name)
				end
			}
		end
		def equipment_autostates_cs_states
			temp = Hash.new([])
			equips.each_value{|i|i.auto_states.each {|k,v| temp[k] += [v]} }
			return temp
		end
		
		def equipment_cs_state_chance
			temp = Hash.new(1.0)
			equips.each_value{|i|i.state_chance.each {|k,v| temp[k] *= v} }
			return temp
		end
	end
end
