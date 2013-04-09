require_relative "baseitem"

module RPG
	class BaseItem
		private
		def equipable_cs_parse(item)
			item.xpath("usable").each {|node|
				extend(UsableItem)
				cs_parse_usable(node)
			}
		end
	end
	module UsableItem
		attr_accessor :max_uses,:empty_stats

		
		def self.extended(obj)
			super
			obj.cs_init_usable
		end
		private
		def usable_cs_init
			cs_init_usable
		end		
		def usable_cs_init_usable
			@max_uses = 1
			@empty_stats = Hash.new(0)
		end
		def usable_cs_to_xml(xml)
			xml.usable{
				xml.empty_stats {
					@empty_stats.each{|k,v|
						xml.stat(v,:name=>k)
					}
				}
				cs_to_xml_usable(xml)
			}
		end
	end
end


module Game
	module UsableItem
		attr_reader :uses
		
		def fill_uses
			@uses=rpg.max_uses
			return nil
		end
		def usable?
			return @uses > 0
		end
		def uses=(value)
			@uses=[value,0].max
			return @uses
		end
		private
		def usable_cs_init
			@uses = rpg.max_uses
		end
		def usable_cs_stat_add(stat,key)
			return rpg.empty_stats[stat]
		end
		
		def usable_cs_stat_multi(stat,key)
			return !rpg.empty_stats[stat].zero? && !@uses.nil? ? @uses : 1
		end
	end
end
