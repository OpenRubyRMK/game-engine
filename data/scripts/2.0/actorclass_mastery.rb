require_relative "actorclass"
require_relative "battler_mastery"
require_relative "levelable_mastery"

module RPG
  class ActorClass
    attr_reader :mastery_rate

    chain "MasteryInfluence" do
      def initialize(*)
        super
        @mastery_rate = Hash.new(1.0)
      end
      
      def _to_xml(xml)
        super
        xml.mastery_rate { @mastery_rate.each {|s,v| xml.mastery(v,:name=>s) }}
      end
      def parse_xml(mastery)
        super
        mastery.xpath("mastery_rate/mastery").each {|node|
          @mastery_rate[node[:name].to_sym] = node.text.to_f
        }
      end
    end
  end
end


module Game
  class ActorClass
    def mastery_rate(k=nil)
      temp = @levels[level]
      temp = rpg.mastery_rate if temp.empty?
      return k ? temp[k] :  temp
    end
  end

  class Actor
    chain "ActorClassMasteryInfluence" do
      def _mastery_rate(key)
        super + @actorclasses.each_value.map{|ac| mastery_rate(key) }
      end
    end
  end
end