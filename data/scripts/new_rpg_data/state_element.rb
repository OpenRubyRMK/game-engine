require_relative "state"
require_relative "element"

module RPG
	class State
		attr_accessor :defence_elements
		
		private
		def element_cs_init
			@defence_elements = Hash.new(1.0)
		end
		def element_cs_to_xml(xml)
			xml.defence_elements{
				@defence_elements.each{|k,v| xml.element(v,:name=>k)}
			}
		end
		def element_cs_parse(state)
			state.xpath("defence_elements/element").each {|node|
				@defence_elements[node[:name].to_sym] = node.text.to_f
			}
		end
	end
end
