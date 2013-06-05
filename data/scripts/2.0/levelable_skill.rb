require_relative "levelable_feature"
require_relative "feature_skill"

module RPG
  module Levelable
    class Level
      
      def skills
        features << Feature.new if features.empty?
        features.first.skills
      end
    end
  end
end

module Game
  module Levelable
    class Level
      #attr_reader :skills
      #chain "SkillInfluence" do
      #  def initialize(rpg)
      #    super
      #    @skills = rpg.skills.map {|n|Skill.new(n)}.group_by(&:name)
      #  end
      #end
      def skills(key)
        l = features.map{|f|f.skills(key)}.flatten
        key ? l : l.group_by(&:name)
      end
    end
  end
end