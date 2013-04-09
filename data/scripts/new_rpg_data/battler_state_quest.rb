require_relative "battler_state"
require_relative "quest"

module RPG
	class Quest
		#works as any
		attr_accessor :finish_state_added
		attr_accessor :finish_state_removed

		attr_accessor :failed_state_added
		attr_accessor :failed_state_removed
		private
		def state_cs_init
			@finish_state_added = {}
			@finish_state_removed = {}
			
			@failed_state_added = {}
			@failed_state_removed = {}
		end
		def state_cs_to_xml_finish(xml)
			xml.state_added { @finish_state_added.each{|k,v| xml.state(:actor=>k,:name=>v)} }
			xml.state_removed { @finish_state_removed.each{|k,v| xml.state(:actor=>k,:name=>v)} }
		end
		def state_cs_to_xml_failed(xml)
			xml.state_added { @failed_state_added.each{|k,v| xml.state(:actor=>k,:name=>v)} }
			xml.state_removed { @failed_state_removed.each{|k,v| xml.state(:actor=>k,:name=>v)} }
		end
	end
end
module Game
	class Battler
		private
		def quest_cs_add_state(k)
			Quest.each do |q|
				return unless q.started
				if q.rpg.failed_state_added[@name] == k
					q.failed = true
				elsif q.rpg.finish_state_added[@name] == k
					q.finish = true
				end
			end
		end
		def quest_cs_remove_state(k)
			Quest.each do |q|
				return unless q.started
				if q.rpg.failed_state_removed[@name] == k
					q.failed = true
				elsif q.rpg.finish_state_removed[@name] == k
					q.finish = true
				end
			end
		end
	end
end
