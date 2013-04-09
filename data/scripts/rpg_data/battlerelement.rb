require_relative "element"
require_relative "proxy"
require_relative "battler"

class Game::Battler
	def elements
		result=Hash.new(1)
		cs_elements_multi { |hash| hash.each {|e,v| result[e] *= v } }
		return result
	end
end
