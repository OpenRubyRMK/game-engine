require_relative "battler_equip"
require_relative "battler_state"

module RPG
  module EquipableItem
    attr_accessor :states_chance,:auto_states,:require_states

    chain "EquipStatesInfluence" do
      def _parse_xml_equipable(item)
        super
        item.xpath("states_chance/state").each {|node|
          @states_chance[node[:name].to_sym] = node.text.to_f
        }
        item.xpath("require_states/state").each {|node|
					require_states << node[:name].to_sym
          State.parse_xml(node) unless node.children.empty?
        }

        item.xpath("auto_states/state").each {|node|
          auto_states << node[:name].to_sym
          State.parse_xml(node) unless node.children.empty?
        }
      end

      def _init_equipable
        super
        @auto_states = []
        @require_states = []
        @states_chance = Hash.new(1.0)
      end

      def _to_xml_equipable(xml)
        super
        xml.states_chance{
          @states_chance.each{|n,v| xml.state(v,:name=>n) }
        }
        xml.require_states{
          @require_states.each{|n| xml.state(:name=>n)}
        }
        xml.auto_states{
          @auto_states.each{|n| xml.state(:name=>n)}
        }
      end
    end

  end
end

module Game
  module EquipableItem
    attr_reader :auto_states
    def states_chance
    	rpg.states_chance
    end
    
		chain "EquipStatesInfluence" do
			def _init_equipable
				super
				@auto_states = rpg.auto_states.map{|n| State.new(n) }.group_by(&:name)
			end
			
		end
  end

  class Battler
    chain "EquipStatesInfluence" do
      def _can_equip(key,item)
        super + RPG::BaseItem[item].require_states.all? {|k|	!states(k).empty?	}
      end

      def _states(key)
      	super + equips.each_value.map{|item|key ? item.auto_states[key]||[] : item.auto_states.values }.flatten
      end

      def _states_chance(key)
				super + equips.each_value.map{|item|key ? item.states_chance[key]||[] : item.states_chance }.flatten
      end
    end
  end
end
