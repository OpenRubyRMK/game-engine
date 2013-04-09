require_relative "actor"
require_relative "battler_state"

module RPG
	class Actor
		attr_accessor :auto_states
		attr_accessor :state_chance #manange the imunity
		attr_accessor :dead_state
		private
		def states_cs_init
			@auto_states = []
			@state_chance = Hash.new(1.0)
			@dead_state = nil
		end
		
		def states_cs_to_xml(xml)
			xml.state_chance{
				@state_chance.each{|n,v| xml.state(v,:name=>n) }
			}
			xml.auto_states{
				@auto_states.each{|n| xml.state(:name=>n) }
			}
			xml.dead_state(:name=>@dead_state)
			
		end
		
		def states_cs_parse(actor)
			actor.xpath("state_chance/state").each {|node|
				@state_chance[node[:name].to_sym] = node.text.to_f
			}
			actor.xpath("auto_states/state").each {|node|
				@auto_states << node[:name].to_sym
				State.parse_xml(node) unless node.children.empty?
			}
			actor.xpath("dead_state").each {|node|
				@dead_state = node[:name].to_sym
				State.parse_xml(node) unless node.children.empty?
			}
		end
	end
end

module Game
	class Actor
		private
		def auto_states_cs_init
			@auto_states = {}
			rpg.auto_states.each{|n| @auto_states[n] = State.new(n) }
		end
		def auto_states_cs_states
			temp = Hash.new([])
			@auto_states.each {|k,v| temp[k] += [v]}
			return temp
		end
		def actor_cs_state_chance
			return rpg.state_chance;
		end
		def dead_state
			return rpg.dead_state
		end
	end
end
