require "test/unit"

require_relative "../enemy"

require_relative "../equippable_item_ability"
require_relative "../equippable_item_mastery"
require_relative "../equippable_item_states"

require_relative "../weapon"

class EquipTest < Test::Unit::TestCase
  def self.startup
    a = RPG::Ability.new(:twohand)
    
    m = RPG::Mastery.new(:axe)
    m.add_level(1)

    w = RPG::Weapon.new(:fire_axe)
    w.equip_type = :axe
    w.equip_requirement.masteries[:all][:axe] = 1

    w = RPG::Weapon.new(:twohandsword)
    w.equip_requirement.abilities[:all][:twohand] = 1
    
    
    RPG::Enemy.new(:warrior)

  end
  
  def test_require_ability
    g=Game::Enemy.new(:warrior)
    assert_false(g.can_equip?(:hand,:twohandsword))
    
    a = g.add_ability(:twohand)
    assert_false(g.can_equip?(:hand,:twohandsword))
    
    a.levelup
    assert_true(g.can_equip?(:hand,:twohandsword))
  end
  
  def test_required_mastery
    g=Game::Enemy.new(:warrior)
    assert_false(g.can_equip?(:hand,:fire_axe))
    
    m=g.add_mastery(:axe)
    assert_false(g.can_equip?(:hand,:fire_axe))
    
    m.levelup
    assert_true(g.can_equip?(:hand,:fire_axe))
  end

end
