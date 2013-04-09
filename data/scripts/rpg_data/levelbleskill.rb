require_relative "skill"
module RPG
	class Skill
		attr_accessor :max_level
		
		private
		def levelble_cs_init#:nodoc:
			@max_level=nil
		end
	end
end
module Game
	class Skill
		attr_reader :level

		def upgrade
			@level=0 if @level.nil?
			@level+=1
		end
				
		private
		def levelble_cs_init#:nodoc:
			@level=nil #um levelble zu aktivieren starte upgrade
		end
	end
end
