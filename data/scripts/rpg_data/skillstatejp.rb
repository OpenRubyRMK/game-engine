require_relative "skilljp"
require_relative "statejp"

module RPG
	class Skill
		attr_proxy :jp_require_states
		private
		def statesjp_cs_init#:nodoc:
			@jp_require_states = Proxy.new([],RPG::State)
		end
	end
	class State
		attr_proxy :jp_require_skills
		private
		def skilljp_cs_init#:nodoc:
			@jp_require_skills = Proxy.new([],RPG::Skill)
		end
	end
end