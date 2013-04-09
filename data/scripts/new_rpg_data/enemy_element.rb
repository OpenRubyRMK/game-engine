require_relative "battler_element"
require_relative "enemy"

module RPG
	class Enemy
		attr_accessor :elements
		def element_cs_init
			@elements = Hash.new(1.0)
		end
		def element_cs_to_xml(xml)
			xml.elements{
				@elements.each{|k,v| xml.element(v,:name=>k)}
			}
		end
		def element_cs_parse(enemy)
			enemy.xpath("elements/element").each {|node|
				@elements[node[:name].to_sym] = node.text.to_f
			}
		end
	end
end
module Game
	class Enemy
		def element_cs_defence_elements
			return rpg.elements
		end
	end
end
