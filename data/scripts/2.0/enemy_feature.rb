require_relative "enemy"
require_relative "battler_feature"

module RPG
  class Enemy
    include Featureable
  end
end
