require_relative "battler"
require_relative "element"

module Game
	class Battler
		def defence_elements#returns {:key=>value}
			hash = Hash.new(1.0)
			cs_defence_elements {|o| o.each{|k,v| hash[k] *=v}}
			return hash
		end
	end
end
