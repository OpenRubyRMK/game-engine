require_relative "battler"
#require_relative "socket"
require_relative "equippable_item"

module Game
  class Battler
    def equip(slot,item)
      #cs_unequiped(slot,@sockets[slot]) unless @sockets[slot].nil?
      @sockets[slot]=item
      #cs_equiped(slot,item)
      return self
    end

    def _can_equip?(slot,item)
      return [true]
    end

    def can_equip?(slot,item)
      return _can_equip(slot,item).all?
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
    end
  end
end
