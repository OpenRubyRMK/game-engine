require_relative "proxy"
require_relative "rpgclasses"
require_relative "gameclasses"
require_relative "translation"
module RPG
	class Quest
		include RPG::RPGClasses
		attr_accessor :icon
		
		attr_proxy :quests
		attr_proxy :start_quests
		
		translation :title,:description
		
		def initialize
			@quests = Proxy.new([],Quest)
			@start_quests = Proxy.new([],Quest)
			cs_init
		end
		
	end
end
module Game
	class Quest
		include Game::GameClasses
		include Enumerable
		attr_accessor :state
		attr_proxy :quests
		def initialize(quest)
			@quests = Proxy.new({},RPG::Quest,Game::Quest)
			self.data=quest
			quest.quests.each {|q| @quests[q] = Quest.new(q) }
			cs_init
		end
		
		def title
			return "" if self.data.title.nil?
			return L[self.data.title]
		end
		def each(&block)
			@quests.each(&block)
		end
		def unactive!
			state = :questlog_state_unactive
		end
		def active!
			state = :questlog_state_active
			self.data.start_quests.each {|qk| @quests[qk].active!}
		end
		def finish!
			state = :questlog_state_finsh
		end
		def abort!
			state = :questlog_state_abort
		end
		
		def unactive?
			return state == :questlog_state_unactive
		end
		def active?
			return state == :questlog_state_active
		end
		def finish?
			return state == :questlog_state_finsh
		end
		def abort?
			return state == :questlog_state_abort
		end
	end
end