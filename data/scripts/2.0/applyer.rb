require_relative "requirement"
require_relative "feature"

class RPG
  class Applyer
    attr_reader :requirement
    attr_reader :feature
    
    def initialize
      @requirement = Requirement.new
      @feature = Feature.new
    end
  end
end