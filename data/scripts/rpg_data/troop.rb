require "enemy"
require "unit"
module RPG
	class Troop
		include RPG::RPGClasses
		translation :name
		
		attr_proxy :members
		def initialize
			@members = Proxy.new([],Enemy)
			Troop.instances.push(self)
		end
	end
end

module Game
	class Troop < Unit
		include Game::GameClasses
		def initialize(troop)
			self.data=troop
			super
			self.members= data.members.map {|e| Enemy.new(e)}
		end
		def name
			return self.data.nil? ? "" : self.data.name
 		end
	end

end