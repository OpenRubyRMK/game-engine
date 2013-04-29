require "test/unit"

require_relative "../mastery_skill"
require_relative "../weapon"
require_relative "../enemy"

class MasteryTest < Test::Unit::TestCase
  def self.startup
    m = RPG::Mastery.new(:axe)
    m.add_level(1) {|l| l.skills << :axe_slash }

    w = RPG::Weapon.new(:fire_axe)
    w.equip_type = :axe

    RPG::Enemy.new(:warrior)

    RPG::Skill.new(:axe_slash)
  end

  def test_skill
    g=Game::Enemy.new(:warrior)

    assert_empty(g.mastery)
    assert_empty(g.active_mastery)

    assert_empty(g.skills)
    assert_empty(g.skills(:axe_slash))

    g.add_mastery(:axe)

    assert_not_empty(g.mastery)
    assert_empty(g.active_mastery)

    assert_empty(g.skills)
    assert_empty(g.skills(:axe_slash))



    g.equip(:hand,Game::Weapon.new(:fire_axe))

    assert_not_empty(g.mastery)
    assert_not_empty(g.active_mastery)
   
    assert_empty(g.skills)
    assert_empty(g.skills(:axe_slash))

    assert_equal(0,g.mastery[:axe].level)
    g.mastery[:axe].levelup
    assert_equal(1,g.mastery[:axe].level)  

    assert_not_empty(g.skills)
    assert_not_empty(g.skills(:axe_slash))
    	
		g.mastery[:axe].levelup -1
		
		assert_equal(0,g.mastery[:axe].level)

    assert_empty(g.skills)
    assert_empty(g.skills(:axe_slash))
  end
end