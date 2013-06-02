require_relative "battler"
require_relative "feature"

module Game
  class Battler
    
    def _features
      []
    end
    
    def features
      return _features
    end
  end
end