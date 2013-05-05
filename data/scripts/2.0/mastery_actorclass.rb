require_relative "actorclass"
require_relative "battler_mastery"

module RPG
  class Mastery
    attr_accessor :actorclasses
    chain "ActorClassInfluence" do
      def initialize(*)
        super
        @actorclasses = []
      end
    end
  end
end

module Game
  class Actor
    chain "MasteryActorClassInfluence" do
      def _active_mastery(m)
        super + [m.rpg.actorclasses.empty? || m.rpg.actorclasses.any? {|ac|
          actorclasses.include?(ac)
          }]
      end
    end
  end
end