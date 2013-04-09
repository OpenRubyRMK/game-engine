require "element"
module RPG
	class SoulPiece
		include RPGClasses
		attr_rpg :element,RPG::Element
		def initialize(element)
			self.element = element
			cs_init
			SoulPiece.instances.push(self)
		end
	end
end