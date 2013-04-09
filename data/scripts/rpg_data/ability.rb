require "csmod"
require "rpgclasses"
require "translation"
module RPG
	class Ability
		include RPGClasses
		translation :name, :description
		
		attr_accessor :atk_boost
		def initialize(name)
			@name = name
			cs_init
			Ability.instances.push(self)
		end
		def icon
		end
	end
end

module Game
	class Ability
		include GameClasses
		attr_accessor :level,:max_level
		def initialize(data,level=0,max_level=10)
			self.data=data
			@level=level
			@max_level=max_level
			cs_init
		end
		
		def name
			return data.name
		end
		
		def description
			return data.description
		end
		
		def upgrade
			unless @max_level.nil?
				if @level < @max_level
					@level+=1
					cs_levelup
				end
			end
		end
		def downgrade
		  @level = [@level-1, 0].max
		end
		
		def icon
			return self.data.icon
		end
		
		def atk_boost
			return self.data.atk_boost * @level
		end
	end
end