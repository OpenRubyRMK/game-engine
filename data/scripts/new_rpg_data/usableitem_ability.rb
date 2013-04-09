require_relative "battler_ability"
require_relative "battler_usableitem"

module RPG
	module UsableItem
		attr_accessor :abilities
		private
		def ability_cs_init_usable
			@abilities = {}
		end

		def ability_cs_to_xml_usable(xml)
			xml.abilities {
				@abilities.each {|n,l|
					xml.item(:name=>n,:level=>l)
				}
			}
		end
	end
end

module Game
	class Battler
		private
		def ability_cs_usable(item)
			return item.rpg.abilities.all? {|n,l| !abilities[n].nil? && abilities[n].level >= l }
		end
	end
end