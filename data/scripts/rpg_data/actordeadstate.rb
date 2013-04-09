require "actorhpmp"
require "battlerdeadstate"
module RPG
	class Actor
		attr_rpg :dead_state, State
	end
end