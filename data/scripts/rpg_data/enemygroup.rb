require_relative "enemy"
module RPG
	class Enemy
		class Group
			include RPG::RPGClasses
			include RPG::Enumerable

			translation :name
			def each(&block)
				RPG::Eneny.find_all {|e| e.groups.include?(self)}.each(&block)
			end
		end
		attr_proxy :groups
		private
		def groups_cs_init#:nodoc:
			@groups = Proxy.new([],Group)
		end
	end
end