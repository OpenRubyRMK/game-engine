require_relative "battler_element"
require_relative "battler_ability"
module RPG
	class Ability
		attr_accessor :defence_elements
		
		private
		def element_cs_init
			@defence_elements = Hash.new(Hash.new(1.0))
		end
		def element_cs_to_xml(xml)
			xml.defence_elements{
				@defence_elements.each{|k,o|
					xml.element(:name=>k){
						o.each{|l,v|
							xml.level(v,:value=>l)
						}
					}
				}
			}
		end
		def element_cs_parse(element)
			element.xpath("defense_elements/element").each {|node|
				n = node[:name].to_sym
				@defence_elements[n] = @defence_elements.default.dup
				node.xpath("level").each{|lnode|
					@defence_elements[n][lnode[:level].to_i]=lnode.text.to_f
				}
			}
		end
	end
end

module Game
	class Ability
		def defence_elements
			temp = Hash.new(1.0)
			rpg.defence_elements.each{|k,o| temp[k] = o[level]}
			return temp
		end
	end
	class Battler
		def ability_cs_defence_elements
			temp = Hash.new(1.0)
			abilities.each_value{|o| o.each{|a| a.defence_elements.each{|k,v| temp[k] *= v }}}
			return temp
		end
	end
end
