require_relative "state_element"
require_relative "battler_state"
require_relative "battler_element"

module Game
	class Battler
		private
		def state_cs_defence_elements
			result = Hash.new(1.0)
			states.each{|k,o|
				o.each {
					RPG::State[k].defence_elements.each{|n,v| result[n] *=v }
				}
			}
			return result
		end
	end
end
