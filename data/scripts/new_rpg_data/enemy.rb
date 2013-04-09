require_relative "battler"
require_relative "baseobject"
module RPG
	class Enemy < BaseObject
		attr_reader :stats
		attr_reader :exp
		#translation :name
		private
		def stats_cs_init
			@stats = Hash.new(0)
			@exp = 0
		end
		def stats_cs_to_xml(xml)
			xml.stats {
				@stats.each{|k,v| xml.stat(v,:name=>k)}
			}
		end
		def stats_cs_parse(enemy)
			enemy.xpath("stats/stat").each {|node|
				@stats[node[:name].to_sym] = node.text.to_i
			}
		end
	end
end
module Game
	class Enemy < Battler
		def rpg
			return RPG::Enemy[@name]
		end
		def basehp
			return rpg.stats[:hp]
		end
		def basemp
			return rpg.stats[:mp]
		end
		def exp
			return stat(:exp,rpg.exp)
		end
	end
end
