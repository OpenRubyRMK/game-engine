require_relative "actor"

module RPG
	class Actor
		attr_accessor :actorclasses
		private
		def actorclass_cs_init
			@actorclasses = Hash.new(1)
		end
		def actorclass_cs_to_xml(xml)
			xml.actorclasses {
				@actorclasses.each {|k,v| xml.actorclass(:name => k,level=>l) }
			}
		end
		def actorclass_cs_parse(node)
			node.xpath("actorclasses/actorclass").each {|ac|
				@actorclasses[ac["name"].to_sym]=ac["level"].to_i
				ActorClass.parse_xml(ac) unless ac.children.empty?
			}
		end
	end
	class ActorClass < BaseObject
		attr_accessor :exp_multiplicator
		attr_accessor :exp
		attr_accessor :level_peractorlvl
		def initialize(name)
			super
			@exp = {}
			100.times{|n| @exp[n] = n * 5 } #TODO find better calc
			@exp_multiplicator = 1.0
		end
		def exp_cs_parse(actorclass)
			actorclass.xpath("//exp").each {|node|
				@exp_multiplicator = node.text.to_f
			}
		end
	end
end
module Game
	class Actor
		attr_accessor :actorclasses
		attr_accessor :removed_actorclasses
		def add_actorclass(k)
			if @removed_actorclasses.include?(k)
				@actorclasses[k] = @removed_actorclasses[k]
				@removed_actorclasses.delete(k)
			else
				@actorclasses[k] = create_actorclass(k)
			end
			cs_add_actorclass(k)
			return self;
		end
			
		def remove_actorclass(k)
			if @actorclasses.include?(k)
				@removed_actorclasses[k] = @actorclasses[k]
				@actorclasses.delete(k)
				cs_remove_actorclass(k)
			end
			return self;
		end
		
		private
		def create_actorclass(k)
			@actorclasses[k] = ActorClass.new(k,@name)
		end
		
		def actorclass_cs_init
			@actorclasses = {}
			@removed_actorclasses = {}
			rpg.actorclasses.each{|ac,l|
				add_actorclass(ac)
				while(@actorclasses[ac].level<l)
					@actorclasses[ac].levelup
				end
			}
		end
		
		def actorclass_cs_gain_exp(n)
			@actorclasses.each_value{|ac| ac.gain_exp(ac.rpg.exp_multiplicator*n) }
		end
		def actorclass_cs_levelup
			@actorclasses.each_value{|ac| ac.levelup }
		end
	end

	class ActorClass
		attr_reader :name
		attr_reader :actor
		attr_reader :level
		def initialize(name,actor)
			@name = name
			@actor = actor
			@level = 0
			@exp = 0
			cs_init
		end
		def rpg
			return RPG::ActorClass[@name]
		end
		def gain_exp(n)
			@exp += n
			cs_gain_exp(n)
			while (@exp >= rpg.exp[@level])
				@level += 1
				cs_levelup
			end
			return self
		end
		def levelup
			gain_exp(rpg.exp[@level] - @exp)
		end
	end
end
