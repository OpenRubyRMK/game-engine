require "test/unit"

require_relative "../enemy_feature"

require_relative "../feature_state"
require_relative "../feature_skill"

require_relative "../equippable_item_features"

require_relative "../weapon"

class FeatureTest < Test::Unit::TestCase
  def self.startup
    RPG::Enemy.new(:warrior)
    
    RPG::State.new(:burn)
    RPG::Skill.new(:fireball)

    w = RPG::Weapon.new(:fire_axe)
    w.equip_features << RPG::Feature.new.tap {|f| f.auto_states << :burn }

      
    w = RPG::Weapon.new(:mage_staff)
    w.equip_features << RPG::Feature.new.tap {|f| f.skills << :fireball }
    
    e = RPG::Enemy.new(:dragon)
    e.features << RPG::Feature.new.tap {|f| f.skills << :fireball }
  end

  def test_states
    g = Game::Enemy.new(:warrior)
    
    w = Game::Weapon.new(:fire_axe)
    
    assert_empty(g.states)
    assert_empty(g.states(:burn))
    
    g.equip(:hand,w)
    
    assert_not_empty(g.states)
    assert_not_empty(g.states(:burn))
  end

  def test_skill
    g = Game::Enemy.new(:warrior)
    
    w = Game::Weapon.new(:mage_staff)
    
    assert_empty(g.skills)
    assert_empty(g.skills(:fireball))
    
    g.equip(:hand,w)
    
    assert_not_empty(g.skills)
    assert_not_empty(g.skills(:fireball))
  end

  def test_enemy
    g = Game::Enemy.new(:warrior)

    assert_empty(g.skills)
    assert_empty(g.skills(:fireball))
    
    g = Game::Enemy.new(:dragon)
    
    assert_not_empty(g.skills)
    assert_not_empty(g.skills(:fireball))

  end
end
