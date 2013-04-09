require_relative "rpgclasses"
module RPG
	class Element
		include RPGClasses
		attr_accessor :state,:visible
		translation :name
		def initialize(name,state=0,visible=true)
			@name = name
			@state = state
			@visible = visible
			Element.instances.push(self)
		end
		def icon
		end
		def physical?
			return [1,3].include?(@state)
		end
		def magical?
			return [2,3].include?(@state)	
		end
		
		
	end
end