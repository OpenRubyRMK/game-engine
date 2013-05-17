require_relative "damage"
require_relative "requirement"

module RPG
  class Target
    
    
    attr_accessor :damages
    
    attr_accessor :user_requirements, :target_requirements
    
    def initialize
      @damages = []
      @user_requirements = Requirement.new
      @target_requirements = Requirement.new
    end

    def _to_xml(xml)
    end
    
    def to_xml(xml)
      xml.target {
        _to_xml(xml)
        
        xml.damages {
          @damages.each{ |dg|
            dg.to_xml(xml)
          }
        }
        
        xml.user_requirements {
          @user_requirements.to_xml(xml)
        }
        xml.target_requirements {
          @target_requirements.to_xml(xml)
        }
      }
    end

  end
end