require_relative "battler"
require_relative "ability"

module Game
  class Battler
    attr_reader :abilities
    def add_ability(k)
      temp = Ability.new(k,self)
      @abilities[k] = temp
      #cs_add_abilitiy(k)
      return temp
    end
    chain "AbilityInfluence" do
      def initialize(*)
        super
        @abilities = {}
      end
    end
  end
end
