=begin
	File equipmentitem_actorclass.rb

	Defines requiremented actorclass for equipment

	used cs:
	RPG::EquipableItem
		cs_init_equipable
		cs_to_xml_equipable
		cs_parse_equipable
	Game::Actor
		cs_can_equip
		cs_remove_actorclass
=end

require_relative "battler_equipment"
require_relative "actorclass"

module RPG
	module EquipableItem
		attr_accessor :actorclasses
		private
		def actorclasses_cs_init_equipable
			@actorclasses = {}
		end
		def actorclass_cs_to_xml_equipable(xml)
			xml.actorclasses{
				actorclasses.each{|ac,l| xml.actorclass(:name=>ac,:level=>l)}
			}
		end
		def actorclass_cs_parse_equipable(item)
			item.xpath("actorclasses/actorclass").each {|node|
				@actorclasses[node[:name].to_sym]=node[:level].to_i
				ActorClass.parse_xml(node) unless node.children.empty?
			}
		end
	end
end

module Game
	class Actor
		private
		def actorclass_cs_can_equip(slot,item)
			return RPG::BaseItem[item].actorclasses.all? {|k,l|
				!@actorclasses[k].nil? && @actorclasses[k].level >= l
			}
		end
		def equip_cs_remove_actorclass(ac)
			equips.each{|k,v|
				if v.rpg.actorclasses.include?(ac)
					equip(k,nil) unless can_equip?(k,v.rpg.name)
				end
			}
		end
	end
end
