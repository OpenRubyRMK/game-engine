require_relative "actor"
require_relative "levelable"

module RPG
  class Actor
    attr_accessor :actorclasses
    chain "ActorClassInfluence" do
      def initialize(*)
        super
        @actorclasses = Hash.new(1)
      end

      def _to_xml(xml)
        super
        xml.actorclasses {
          @actorclasses.each {|k,v| xml.actorclass(:name => k,level=>l) }
        }
      end

      def _parse_xml(node)
        super
        node.xpath("actorclasses/actorclass").each {|ac|
          @actorclasses[ac["name"].to_sym]=ac["level"].to_i
          ActorClass.parse_xml(ac) unless ac.children.empty?
        }
      end
    end
  end

  class ActorClass < BaseItem
    include Levelable
    #    attr_accessor :exp_multiplicator
    #    attr_accessor :exp
    #    attr_accessor :level_peractorlvl
    def initialize(name)
      super
      #      @exp = {}
      #      100.times{|n| @exp[n] = n * 5 } #TODO find better calc
      #      @exp_multiplicator = 1.0
    end
    #    def exp_cs_parse(actorclass)
    #      actorclass.xpath("//exp").each {|node|
    #        @exp_multiplicator = node.text.to_f
    #      }
    #    end
  end
end

module Game
  class Actor
    attr_accessor :actorclasses
    attr_accessor :removed_actorclasses

    chain "ActorClassInfluence" do
      def initialize(*)
        super
        @actorclasses = {}
        @removed_actorclasses = {}

        rpg.actorclasses.each{|ac,l|
          add_actorclass(ac)
          #while(@actorclasses[ac].level<l)
          #  @actorclasses[ac].levelup
          #end
        }
      end
    end

    def add_actorclass(k)
      notify_observers(:added_actorclass) {
        if @removed_actorclasses.include?(k)
          @actorclasses[k] = @removed_actorclasses.delete(k)
        else
          @actorclasses[k] ||= ActorClass.new(k,self)
        end
      }
      return self
    end

    def remove_actorclass(k)
      if @actorclasses.include?(k)
        notify_observers(:remove_actorclass) {
          @removed_actorclasses[k] = @actorclasses.delete(k)
        }
        #cs_remove_actorclass(k)
      end
      return self
    end
  end

  class ActorClass < BaseObject

    attr_reader :actor
    attr_accessor :level

    include Levelable
    def initialize(name,actor)
      super(name)
      @actor = actor
      @level = 0
      @exp = 0
    end

    def rpg
      return RPG::ActorClass[@name]
    end
  end
end
