require_relative "battler_ability"
require_relative "battler_state"
require_relative "levelable_state"

module RPG
  class Ability
    attr_reader :state_rate

    chain "StateInfluence" do
      def initialize(*)
        super
        @state_rate = Hash.new(1.0)
      end
      
      def _to_xml(xml)
        super
        xml.state_rate { @state_rate.each {|s,v| xml.state(v,:name=>s) }}
      end
      def parse_xml(state)
        super
        state.xpath("state_rate/state").each {|node|
          @state_rate[node[:name].to_sym] = node.text.to_f
        }
      end
    end
  end
end


module Game
  class Ability    
    def state_rate(k=nil)
      temp = @levels[level]
      temp = rpg.state_rate if !temp || temp.empty?
      return k ? temp[k] :  temp
    end
  end

  class Battler
    chain "AbilityStateInfluence" do
      def _state_rate(key)
        super + @abilities.each_value.map{|ab| ab.state_rate(key) }
      end
    end
  end
end