=begin

actormsg => [msg,msg]

=end
require_relative "baseobject"
module RPG
	class Topic < BaseObject
		attr_accessor :answer
		attr_accessor :shortcut
		attr_accessor :enabled
		attr_accessor :caption
		def initialize(name)
			@shortcut = name
			@enabled = nil # nil means to use autochecking
			super
		end
	end
	class Dialog < BaseObject
		include Enumerable
		def initialize(name)
			super
			@topics=[]
		end

		def << (value)
			@topics << value.to_sym
			return self
		end
		def [](i)
			return Topic[@topics[i]]
		end
		def each
			return to_enum(__method__) unless block_given?
			@topics.each{|i|yield Topic[i]}
			return self
		end
	end
	
end

module Game
	class Topic
		attr_reader :name
		attr_writer :enabled
		def initialize(name)
			#@owner = owner
			@name = name
			@enabled = nil # nil means to use autochecking
			cs_init
		end
		def rpg
			return RPG::Topic[@name]
		end
		def enabled
			return @enabled.nil? ? cs_enabled.all? : @enabled
		end
		
		def progress!
			cs_progress
			return self
		end
		
		#def enabled_cs_enabled
		#	@enabled
		#end
	end
	class Dialog
		attr_reader :name
		attr_writer :greeting
		def initialize(name)
			@name = name.to_sym
			@topics = {}
			@greeting = :"#{name}_greeting"
			cs_init
			Dialog[@name]=self
			rpg.map(&:name).each{|k| @topics[k]=Topic.new(k)}
				
		end
		def rpg
			return RPG::Dialog[@name]
		end
		def [](value)
			return @topics[value.to_sym]
		end
		def each(&block)
			return to_enum(__method__) unless block_given?
			@topics.each_value(&block)
			return self
		end
		def greeting
			self[@greeting]
		end
		include Enumerable
		class << self
			include Enumerable
			def each
				raise NotImplementedError
			end
			def [](i)
				raise NotImplementedError
			end
			def []=(i,o)
				raise NotImplementedError
			end
		end
	end
end

#======================
#linked_topic
#======================
module RPG
	class Topic
		attr_accessor :lnk_tpc
		def linked_topic_cs_init
			@lnk_tpc = {}
		end
	end
end
module Game
	class Topic
		def linked_topic_cs_progress
			rpg.lnk_tpc.each{|(dialog,topic),status|
				Dialog[dialog.to_sym][topic.to_sym].enabled=status
			}
		end
	end
end
#======================
#linked_greetings
#======================
module RPG
	class Topic
		attr_accessor :lnk_grt
		def linked_greetings_cs_init
			@lnk_grt = {}
		end
	end
end
module Game
	class Topic
		def linked_greetings_cs_progress
			rpg.lnk_grt.each{|dialog,topic|
				Dialog[dialog.to_sym].greeting = topic.to_sym
			}
		end
	end
end

#======================
#Party Dialog Holder
#======================
require_relative "party"

module Game
	class Party
		attr_reader :dialogs
		def dialogs_cs_init
			@dialogs = {}
			#rpg.quests.each {|k| add_quest(k)}
		end
	end
	class << Dialog
		def each(&block)
			return to_enum(__method__) unless block_given?
			Party.current_party.dialogs.each_value(&block)
			return self
		end
		def [](i)
			Party.current_party.dialogs[i]
		end
		def []=(i,o)
			Party.current_party.dialogs[i]=o
		end
	end
end

#======================
#Message Quest
#======================

require_relative "quest"
module RPG
	class Topic
		attr_accessor :require_quest
		attr_accessor :modify_quest
		
		def quest_cs_init
			@require_quest = {}
			@modify_quest = {} #quest => new_state
		end
	end
end
module Game
	class Topic
		def quest_cs_enabled
			rpg.require_quest.all?{|k,v|Quest[k].state==v}
		end
		def quest_cs_progress
			rpg.modify_quest.each{|k,v|Quest[k].state = v}
		end
	end
end

