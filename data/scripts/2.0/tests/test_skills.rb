require "test/unit"
require "turn/autorun"


require_relative "../enemy_skill"
require_relative "../ability_skill"

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

end