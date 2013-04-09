require_relative "ability"
require_relative "proxy"
require_relative "battler"
require_relative "gameclasses"
module Game
	class Battler
		attr_proxy  :abilities
		def add_ability(ability,level=0,max_level=10)
			return if abilities.include?(ability)
			abilities[ability]= Ability.new(ability,level,max_level)
			return self
		end
		private
		def abilities_cs_init#:nodoc:
			@abilities = Proxy.new({},RPG::Ability,Game::Ability)
		end
		def abilities_cs_stat_add(stat)#:nodoc:
			temp = 0
			abilities.vaules.each {|atri| atri.send("#{stat}_boost") if atri.respond_to?("#{stat}_boost") }
			return temp
		end
	end
end