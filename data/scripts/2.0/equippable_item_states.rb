require_relative "battler_equip"
require_relative "battler_state"

require_relative "requirement_states"

module RPG
  module EquippableItem
    attr_accessor :states_chance,:auto_states

    chain "EquipStatesInfluence" do
      def _parse_xml_equippable(item)
        super
        item.xpath("states_chance/state").each {|node|
          @states_chance[node[:name].to_sym] = node.text.to_f
        }

        item.xpath("auto_states/state").each {|node|
          auto_states << node[:name].to_sym
          State.parse_xml(node) unless node.children.empty?
        }
      end

      def _init_equippable
        super
        @auto_states = []
        @states_chance = Hash.new(1.0)
      end

      def _to_xml_equippable(xml)
        super
        xml.states_chance{
          @states_chance.each{|n,v| xml.state(v,:name=>n) }
        }
        
        xml.auto_states{
          @auto_states.each{|n| xml.state(:name=>n)}
        }
      end
    end

  end
end

module Game
  module EquippableItem
    attr_reader :auto_states
    def states_chance
      rpg.states_chance
    end

    chain "EquipStatesInfluence" do
      def _init_equippable
        super
        @auto_states = rpg.auto_states.map{|n| State.new(n) }.group_by(&:name)
      end

    end
  end

  class Battler
    chain "EquipStatesInfluence" do
      def _states(key)
        super + equips.each_value.map{|item|key ? item.auto_states[key]||[] : item.auto_states.values }.flatten
      end

      def _states_chance(key)
        super + equips.each_value.map{|item|key ? item.states_chance[key]||[] : item.states_chance }.flatten
      end
    end
  end
end
