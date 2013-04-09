require_relative "party"
require_relative "quest"

module RPG
	class Party
		attr_accessor :quests
		private
		def quests_cs_init
			@quests = []
		end
		def quests_cs_to_xml(xml)
			xml.quests{ @quests.each{|m| xml.quest(:name=>m)}}
		end
		def quests_cs_parse(node)
			node.xpath("quests/quest").each {|q|
				@quests << q["name"].to_sym
				Quest.parse_xml(ac) unless q.children.empty?
			}
		end
	end
	class Quest
		#works as any
		attr_accessor :finish_actor_added
		attr_accessor :finish_actor_removed

		attr_accessor :failed_actor_added
		attr_accessor :failed_actor_removed
		private
		def party_cs_init
			@finish_actor_added = []
			@finish_actor_removed = []
			
			@failed_actor_added = []
			@failed_actor_removed = []
		end
		def party_cs_to_xml_finish(xml)
			xml.actor_added { @finish_actor_added.each{|k| xml.actor(:name=>k)} }
			xml.actor_removed { @finish_actor_removed.each{|k| xml.actor(:name=>k)} }
		end
		def party_cs_to_xml_failed(xml)
			xml.actor_added { @failed_actor_added.each{|k| xml.actor(:name=>k)} }
			xml.actor_removed { @failed_actor_removed.each{|k| xml.actor(:name=>k)} }
		end
	end
end
module Game
	class Party
		attr_reader :quests
		
		def add_quest(k)
			@quests[k] = Quest.new(k)
		end
		
		private
		def quests_cs_init
			@quests = {}
			rpg.quests.each {|k| add_quest(k)}
		end
		
		def quests_cs_add_member(k)
			@quests ||= {}
			@quests.each_value do |q|
				return unless q.started
				if q.rpg.failed_actor_added.include?(k)
					q.failed = true
				elsif q.rpg.finish_actor_added.include?(k)
					q.finish = true
				end
			end
		end
		def quests_cs_remove_member(k)
			@quests ||= {}
			@quests.each_value do |q|
				return unless q.started
				if q.rpg.failed_actor_removed.include?(k)
					q.failed = true
				elsif q.rpg.finish_actor_removed.include?(k)
					q.finish = true
				end
			end
		end
	end
	class Quest
		class << self
			def each(&block)
				Party.current.quests.each_value(&block)
				return self
			end
			def [](i)
				Party.current.quests[i]
			end
			def []=(i,o)
				Party.current.quests[i]=o
			end
		end
	end
end
