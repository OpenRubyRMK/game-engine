require_relative "battler_ability"
require_relative "enemy"

module RPG
	class Enemy
		attr_accessor :abilities
		private
		def abilities_cs_init
			@abilities = {}
		end
		
		def abilities_cs_to_xml(xml)
			xml.abilities{
				@abilities.each{|k,l| xml.ability(:name=>k,:level=>l) }
			}
		end
		
		def abilities_cs_parse(enemy)
			enemy.xpath("abilities/ability").each {|node|
				@abilities[node[:name].to_sym]=node[:level].to_i
				Ability.parse_xml(node) unless node.children.empty?
			}
		end
	end
end

module Game
	class Enemy
		private
		def enemy_abilities_cs_init_after
			rpg.abilities.each do |k,l|
				temp=add_ability(k)
				l.times {temp.levelup}
			end
		end
	end
end
