require "proxy"
require "set"
require "element"
require "rpgclasses"
module RPG
	class Target
		include RPGClasses
		attr_accessor :any,:ally,:enemy # zahlenwerte wieviele der trifft, vllt auch range (oder all)

		attr_proxy :any_damage,:ally_damage,:enemy_damage,:user_damage # proxy: {ProxySet<Element> => Integer}

		attr_accessor :any_random,:ally_random,:enemy_random # bool werte ob der zufällig wählt
		
		def initialize
			@any_damage = Proxy.new(Hash,Proxy.new(Set,RPG::Element),Float)
			@ally_damage = Proxy.new(Hash,Proxy.new(Set,RPG::Element),Float)
			@enemy_damage = Proxy.new(Hash,Proxy.new(Set,RPG::Element),Float)
			@user_damage = Proxy.new(Hash,Proxy.new(Set,RPG::Element),Float)
			cs_init
			Target.instances.push(self)
		end
	end
end