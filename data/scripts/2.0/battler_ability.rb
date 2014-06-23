require_relative "battler"
require_relative "ability"

module Game
  class Battler
    attr_reader :abilities
    def add_ability(k)
      return if @abilities.include?(k)
      return notify_observers(:added_ability) {
        @abilities[k] = Ability.new(k,self)
      }
    end
    chain "AbilityInfluence" do
      def initialize(*)
        super
        @abilities = {}
      end
    end
  end
end
