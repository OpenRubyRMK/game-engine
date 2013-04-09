require_relative "battler_element"
require_relative "actorclass"
module RPG
	class ActorClass
		attr_accessor :elements
		private
		def element_cs_init
			@elements = Hash.new(1.0)
		end
		def element_cs_to_xml(xml)
			xml.elements{
				@elements.each{|k,v| xml.element(v,:name=>k)}
			}
		end
		def element_cs_parse(actorclass)
			actorclass.xpath("elements/element").each {|node|
				@elements[node[:name].to_sym] = node.text.to_f
			}
		end
	end
end
module Game
	class Actor
		private
		def actorclass_cs_defence_elements
			result = Hash.new(1.0)
			@actorclasses.each_value{|ac| ac.rpg.elements.each {|k,v| result[k]*=v}}
			return result
		end
	end
end
