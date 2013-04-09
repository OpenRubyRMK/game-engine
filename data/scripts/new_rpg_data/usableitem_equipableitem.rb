require_relative "battler_equipment"
require_relative "battler_usableitem"
require_relative "group"
module RPG
	module UsableItem
		attr_accessor :equipeditems
		attr_accessor :equipedgroups
		private
		def equiped_cs_init_usable
			@equipeditems = []
			@equipedgroups = []
		end
		def equiped_cs_to_xml_usable(xml)
			xml.equipeditems {
				@equipeditems.each {|n|
					xml.item(:name=>n)
				}
			}
			xml.equipedgroups {
				@equipedgroups.each {|n|
					xml.group(:name=>n)
				}
			}
		end 
	end
end

module Game
	class Battler
		private
		def equiped_cs_usable(item)
			eq = equips.values.map(&:to_sym)
			return false unless item.rpg.equipeditems.all? {|i| eq.include?(i.to_sym)}
			return item.rpg.equipedgroups.all?{|i| eq.any?{|e|RPG::Group[i.to_sym].members.include?(e.to_sym)}}			
		end
	end
end