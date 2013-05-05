require_relative "base_item"
require_relative "chain_module"

module RPG
  class BaseItem
    chain "UsableItem" do
      def _parse_xml(item)
        super
        item.xpath("usable").each {|node|
          extend(EquippableItem)
          _parse_xml_equippable(node)
        }
      end
    end

  end

  module UsableItem
    attr_accessor :max_uses,:empty_stats
    def self.extended(obj)
      super
      obj._init_usable
    end

    def _init_usable
      @max_uses = 1
      @empty_stats = Hash.new(0)
    end

    def initialize(*)
      super
      _init_usable
    end

    def _to_xml(xml)
      super
      xml.equippable{ _to_xml_usable(xml) }
    end

    def _to_xml_usable(xml)
      xml.usable{
        xml.empty_stats {
          @empty_stats.each{|k,v|
            xml.stat(v,:name=>k)
          }
        }
      }
    end
  end
end

module Game
  module UsableItem
    attr_reader :uses
    def fill_uses
      @uses=rpg.max_uses
      return nil
    end

    def usable?
      return @uses ? @uses > 0 : true
    end

    def uses=(value)
      @uses=[value,0].max
      return @uses
    end

    def _init_usable
      fill_uses
    end

    def self.extended(obj)
      super
      obj._init_usable
    end

    def initialize(*)
      super
      _init_usable
    end
  end
end
