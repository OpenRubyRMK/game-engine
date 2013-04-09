require_relative "actorclass"
require_relative "quest"

module RPG
	class Quest
		#works as any
		attr_accessor :finish_actorclass_added
		attr_accessor :finish_actorclass_removed

		attr_accessor :failed_actorclass_added
		attr_accessor :failed_actorclass_removed
		private
		def actorclass_cs_init
			@finish_actorclass_added = {}
			@finish_actorclass_removed = {}
			
			@failed_actorclass_added = {}
			@failed_actorclass_removed = {}
		end
		def actorclass_cs_to_xml_finish(xml)
			xml.actorclass_added { @finish_actorclass_added.each{|k,v| xml.actorclass(:actor=>k,:name=>v)} }
			xml.actorclass_removed { @finish_actorclass_removed.each{|k,v| xml.actorclass(:actor=>k,:name=>v)} }
		end
		def actorclass_cs_to_xml_failed(xml)
			xml.actorclass_added { @failed_actorclass_added.each{|k,v| xml.actorclass(:actor=>k,:name=>v)} }
			xml.actorclass_removed { @failed_actorclass_removed.each{|k,v| xml.actorclass(:actor=>k,:name=>v)} }
		end
	end
end
module Game
	class Actor
		private
		def quest_cs_add_actorclass(k)
			Quest.each do |q|
				return unless q.started
				if q.rpg.failed_actorclass_added[@name] == k
					q.failed = true
				elsif q.rpg.finish_actorclass_added[@name] == k
					q.finish = true
				end
			end
		end
		def quest_cs_remove_actorclass(k)
			Quest.each do |q|
				return unless q.started
				if q.rpg.failed_actorclass_removed[@name] == k
					q.failed = true
				elsif q.rpg.finish_actorclass_removed[@name] == k
					q.finish = true
				end
			end
		end
	end
end
