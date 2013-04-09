require "actorclass"

module RPG
	class SkillTree
		include RPGClasses
		translation :name
	end
	class ActorClass
		attr_reader :skilltrees
		def skilltrees=(value)
			@skilltrees.replace(value)
		end
		private
		def skilltrees_cs_init
			@skilltrees = Proxy.new([],SkillTree)
		end
	end
end