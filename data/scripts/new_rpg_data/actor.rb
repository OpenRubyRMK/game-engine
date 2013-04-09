require_relative "baseobject"
require_relative "battler"

module RPG
	class Actor < BaseObject
		attr_accessor :start_level
		attr_accessor :exp
		attr_accessor :hp,:mp
		def initialize(name)
			super
			@start_level = 1
			@hp = {1=>50}
			@mp = {1=>5}
			#@exp = {}
			#100.times{|n| @exp[n] = n * 5 } #TODO find better calc
		end
		private
		def level_cs_parse(actor)
			actor.xpath("./exp").each {|node|
				@start_level = node[:start_level]
			}
		end
	end
end
module Game
	class Actor < Battler
		attr_reader :level
		def initialize(name)
			@name = name
			@level = rpg.start_level
			super
			@exp = 0
		end
		def rpg
			return RPG::Actor[@name]
		end
		def gain_exp(n)
			@exp += n
			cs_gain_exp(n)
			while (@exp >= rpg.exp[@level])
				@level += 1
				cs_levelup
			end
			return self
		end
		def levelup
			gain_exp(rpg.exp[@level] - @exp)
		end
		
		def basehp
			return rpg.hp[level]
		end
		def basemp
			return rpg.mp[level]
		end
	end
end
