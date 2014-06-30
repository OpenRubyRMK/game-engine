require_relative "unit"
require_relative "actor_state"

module RPG
  class Party < BaseObject
    attr_accessor :members
    def initialize(name)
      super
      @members = []
    end
    private
    def _to_xml(xml)
      xml.members{
        @members.each{|m| xml.member(:name=>m) }
      }
    end
    def _parse_xml(node)
      node.xpath("members/member").each {|node|
        @members << node["name"].to_sym
        Actor.parse_xml(node) unless node.children.empty?
      }
    end
  end
end
module Game
  class Party < Unit
    def rpg
      return RPG::Party[@name]
    end
    def create_member(key)
      return Game::Actor.new(key)
    end
  end
end
