require_relative "baseitem"

module RPG
	class BaseItem
		private
		def equipable_cs_parse(item)
			item.xpath("equipable").each {|node|
				extend(EquipableItem)
				cs_parse_equipable(node)
			}
		end
	end
	module EquipableItem
		attr_reader :equip_stats
		
		def self.extended(obj)
			super
			obj.cs_init_equipable
		end
		private
		def equipable_cs_init_equipable
			@equip_stats=Hash.new(0)
		end
		
		def equipable_cs_to_xml(xml)
			xml.equipable{
				xml.stats{
					@equip_stats.each{|name,v|
						xml.stat(v,:name=>name)
					}
#					cs_to_xml_equipable_stats(xml)
				}
				cs_to_xml_equipable(xml)
			}
		end
	end
end
module Game
	module EquipableItem
		def equip_stat(key)
			return stat(key,rpg.equip_stats[key],:equip)
		end
	end
end
