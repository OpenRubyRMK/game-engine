require_relative "battlerhpmp"
require_relative "battlerstate"

module Game
	class Battler
		private
		def dead_cs_hp_change#:nodoc:
			if self.data.respond_to?(:dead_state)
				if @hp == 0
					add_state(self.data.dead_state)
				else
					remove_state(self.data.dead_state) if states.include?(self.data.dead_state)
				end
			end
		end
	end
end