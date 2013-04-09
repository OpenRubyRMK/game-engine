require_relative "battler"
require_relative "inventar"
module Game
	class Battler
		include Inventar
		private		
		def inventar_cs_unequiped(slot,item)
			gain_item(item)
		end
	end
end
