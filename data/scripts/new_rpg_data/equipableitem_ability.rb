=begin
	File equipmentitem_ability.rb

	used cs:
	RPG::EquipableItem
		cs_init_equipable
		cs_to_xml_equipable
		cs_parse_equipable
	Game::Ability
		equipable_cs_level
	Game::Battler
		cs_can_equip
=end

require_relative "battler_equipment"
require_relative "battler_ability"

module RPG
	module EquipableItem
		attr_accessor :required_abilities,:level_abilities
		private
		def ability_cs_init_equipable
			@required_abilities = Hash.new(0)
			@level_abilities = Hash.new(0)
		end
		def ability_cs_to_xml_equipable(xml)
			xml.required_abilities {
				@required_abilities.each{|k,l| xml.ability(:name=>k,:level=>l) }
			}
			xml.level_abilities {
				@level_abilities.each{|k,l| xml.ability(:name=>k,:value=>l) }
			}
			
		end
		
		def ability_cs_parse_equipable(item)
			item.xpath("required_abilities/ability").each {|node|
				@required_abilities[node[:name].to_sym]=node[:level].to_i
				Ability.parse_xml(node) unless node.children.empty?
			}
			item.xpath("level_abilities/ability").each {|node|
				@level_abilities[node[:name].to_sym]=node[:value].to_i
				Ability.parse_xml(node) unless node.children.empty?
			}
		end
	end
end
module Game
	class Ability
		private
		def equipable_cs_level
			return @battler.equips.map {|k,e| e.level_abilities[@name]}.inject(0,:+)
		end
	end

	class Battler
		private
		def ability_cs_can_equip(key,item)
			return RPG::BaseItem[item].required_abilities.all? {|k,l|
				!abilities[k].nil? && abilities[k].level >= l
			}
		end
	end
end

