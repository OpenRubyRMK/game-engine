require_relative "levelable"
require_relative "skill"

module RPG
  module Levelable
    class Level
      attr_accessor :skills
      chain "SkillInfluence" do
        def initialize(*)
          @skills = []
        end
      end
    end
  end
end
module Game
  module Levelable
    class Level
      attr_reader :skills    
      chain "SkillInfluence" do
        def initialize(rpg)
          super
          @skills = rpg.skills.map {|n|Skill.new(n)}.group_by(&:name)
        end
      end
    end
  end
end