require_relative "game_object"
require_relative "battler_state"

module Game
  class Unit < BaseObject
    include Enumerable
    
    def initialize(name)
      super
      @members = []
      @removed_members = []
      rpg.members.each {|k| add_member(k) }
    end
    
    def each(&block)
      return to_enum(__method__) { @members.size } unless block_given?
      @members.each(&block)
      return self
    end
    
    def add_member(battler)
      if @removed_members.include?(battler)
        @members << @removed_members.delete(battler)
      elsif 
        @members << (battler.is_a?(Battler) ? battler : create_member(battler))
      end
    end
    
    def remove_member(battler)
      if @members.include?(battler)
        @removed_members << @members.delete(battler)
      end
    end
    
    def create_member(battler)
      raise NotImplementedError
    end
    
    
    def alive_members
      return @members.select(&:alive?)
    end
    
    def dead_members
      return @members.select(&:dead?)
    end
  end
end