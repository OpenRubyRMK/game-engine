require_relative "levelable_feature"
require_relative "feature_skill"

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
        l = features.flat_map{|f|f.skills(key)}
        key ? l : l.group_by(&:name)
      end
    end
  end
end
