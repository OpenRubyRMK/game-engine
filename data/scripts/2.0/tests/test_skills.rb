require "test/unit"

require_relative "../enemy_skill"
require_relative "../ability_skill"

require_relative "../actorclass_skill"

class SkillTest < Test::Unit::TestCase
  def self.startup
    sk = RPG::Skill.new(:fireball)
    sk = RPG::Skill.new(:iceball)

    en = RPG::Enemy.new(:slime)
    en.skills << :fireball

    en2 = RPG::Enemy.new(:human)
    
    #set abilities
    a = RPG::Ability.new(:fireart)
    a.add_level(1) {|lv| lv.skills << :fireball }
    #p a
      
    RPG::Actor.new(:alex)
    ac = RPG::ActorClass.new(:warrior)
    ac.add_level(1) {|lv| lv.skills << :fireball }
    ac.add_level(2) {|lv| lv.skills << :iceball }
        
  end

  def test_enemy_skills

    gs = Game::Enemy.new(:slime)
    assert_not_empty(gs.skills)
    assert_not_empty(gs.skills(:fireball))
    assert_empty(gs.skills(:iceball))

    gh = Game::Enemy.new(:human)
    assert_empty(gh.skills)
    assert_empty(gh.skills(:fireball))
    assert_empty(gh.skills(:iceball))

    gh.add_skill(:iceball)

    assert_not_empty(gh.skills)
    assert_empty(gh.skills(:fireball))
    assert_not_empty(gh.skills(:iceball))

    gh.remove_skill(:iceball)

    assert_empty(gh.skills)
    assert_empty(gh.skills(:fireball))
    assert_empty(gh.skills(:iceball))

  end
  
  def test_ability_skills
    gh = Game::Enemy.new(:human)
    assert_empty(gh.skills)
    
    assert_empty(gh.abilities)
    assert_not_include(gh.abilities,:fireart)
    
    f = gh.add_ability(:fireart)

    assert_not_empty(gh.abilities)
    assert_includes(gh.abilities,:fireart)
    
    assert_empty(f.skills)
    assert_empty(gh.skills)
    assert_empty(f.skills(:fireball))
    assert_empty(gh.skills(:fireball))
        
    f.levelup # now level 1

    assert_not_empty(f.skills)
    assert_not_empty(gh.skills)
    assert_not_empty(f.skills(:fireball))
    assert_not_empty(gh.skills(:fireball))

    f.levelup # now level 2

    assert_empty(f.skills)
    assert_empty(gh.skills)
    assert_empty(f.skills(:fireball))
    assert_empty(gh.skills(:fireball))
    
  end
  
  def test_skills_actorclass
    ga=Game::Actor.new(:alex)
    
    assert_empty(ga.skills)
    
    ga.add_actorclass(:warrior)
    ac = ga.actorclasses[:warrior]
    
    assert_empty(ga.skills)
    assert_empty(ac.skills)
    assert_empty(ga.skills(:fireball))
    assert_empty(ac.skills(:fireball))
    assert_empty(ga.skills(:iceball))
    assert_empty(ac.skills(:iceball))
    
    ac.level += 1 #now level 1 learned fireball

    assert_not_empty(ga.skills)
    assert_not_empty(ac.skills)
    assert_not_empty(ga.skills(:fireball))
    assert_not_empty(ac.skills(:fireball))
    assert_empty(ga.skills(:iceball))
    assert_empty(ac.skills(:iceball))

    ac.level += 1 #now level 2 learned iceball

    assert_not_empty(ga.skills)
    assert_not_empty(ac.skills)
    assert_not_empty(ga.skills(:fireball))
    assert_not_empty(ac.skills(:fireball))
    assert_not_empty(ga.skills(:iceball))
    assert_not_empty(ac.skills(:iceball))
    
    ga.remove_actorclass(:warrior) #remove actorclass, alex lose the learned skills

    assert_empty(ga.skills)
    assert_not_empty(ac.skills)
    assert_empty(ga.skills(:fireball))
    assert_not_empty(ac.skills(:fireball))
    assert_empty(ga.skills(:iceball))
    assert_not_empty(ac.skills(:iceball))
      
    ga.add_actorclass(:warrior) #add actorclass again, alex gets the loosed skills
    
    assert_not_empty(ga.skills)
    assert_not_empty(ac.skills)
    assert_not_empty(ga.skills(:fireball))
    assert_not_empty(ac.skills(:fireball))
    assert_not_empty(ga.skills(:iceball))
    assert_not_empty(ac.skills(:iceball))
        

  end

end