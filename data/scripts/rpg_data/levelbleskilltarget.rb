#require "usabletarget"
require_relative "levelbleskill"

module RPG
	class Skill
		attr_proxy :targets_lvl
		private
		def targetlevelble_cs_init#:nodoc:
			#{level => [RPG::Target] }
			@targets_lvl = Proxy.new(Hash,Integer,Proxy.new([],RPG::Target))
		end
	end
end
