require_relative "battler"
require_relative "featureable"

module Game
  class Battler
    include Featureable
    def available_features
      features.select {|f| f.requirement.check(self) }
    end
  end
end
