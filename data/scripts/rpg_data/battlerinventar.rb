require "battler"
require "inventar"

module Game
	class Battler
		attr_reader :inventar
		private
		def inventar_cs_init
			@inventar = Inventar.new
		end
	end
end