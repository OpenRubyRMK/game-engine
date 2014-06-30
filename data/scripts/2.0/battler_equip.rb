require_relative "battler"
#require_relative "socket"
require_relative "equippable_item"

module RPG
	class BattlerRequirement
    attr_reader :equipment
    
    chain "EquipInfluence" do
      def initialize
        super
        @equipment = init_check(ItemRequirement.new)
      end
      
      def to_xml(xml)
        super
        @equipment.each {|k,v|
        	xml.equipment(:type => k) { v.to_xml(xml) } unless v.empty?
    		}
      end

      def _check(battler)
      	eq = battler.equips.values
        super + [eq.any? {|item| @equipment[:any].check(item) }]
      end
      
      def _empty
      	super + [check_empty(@equipment)]
      end
      
      def parse_xml(xml)
        super
        xml.xpath("equipment").each {|node| @equipment[node[:type].to_sym].parse_xml(node) }
      end
    end
  end
end

module Game
  class Battler
    def equip(slot,item)
      #cs_unequiped(slot,@sockets[slot]) unless @sockets[slot].nil?

      notify_observers(:equiped) {
        @sockets[slot]=item
        {:slot => slot, :item => item}
      }

      return self
    end

    def _can_equip(slot,item)
      return [RPG::BaseItem[item].equip_requirement.check(self)]
    end

    def _item_indestructibly(item)
      return [item.indestructibly]
    end

    def _item_destructibly(item)
      return [item.destructibly]
    end
    
    def can_equip?(slot,item)
      return _can_equip(slot,item).all?
    end

    def item_indestructibly?(item)
      return _item_indestructibly(item).any? && _item_destructibly(item).none?
    end
    
    def add_socket(slot)
      @sockets[slot]=nil
      #cs_socket_added(slot)
      return self
    end

    def equips
      #equipment_cs_init if @sockets.nil?
      @sockets ||= {}
      return @sockets.reject{|k,v|v.nil?}
    end

    chain "EquipInfluence" do
      def initialize(*)
        super
        @sockets={}
        if rpg.respond_to?(:sockets)
          rpg.sockets.each{|s| add_socket(s) }
        end
      end
      private

      def _stat_add(stat)
        super + equips.values.map{|item| item.equip_stat(stat)}
      end

      def _stat_multi(stat)
        super + equips.values.map{|item| item.equip_stat_multi(stat)}
      end
    end
  end
end
