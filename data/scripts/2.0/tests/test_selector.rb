require "test/unit"

require_relative "../enemy"

require_relative "../state_equipment"

require_relative "../weapon"

class SelectorTest < Test::Unit::TestCase
  def self.startup
    RPG::Enemy.new(:warrior)

    w = RPG::Weapon.new(:fire_axe)
    w.equip_type = :axe

    w = RPG::Weapon.new(:legenary_axe)
    w.indestructibly = true
    w.equip_type = :axe

    w = RPG::Weapon.new(:broken_axe)
    w.destructibly = true
    w.equip_type = :axe

    s = RPG::State.new(:axe_protection)
    s.indestructible_item.equip_type[:all] << :axe

    s = RPG::State.new(:fireaxe_protection)
    s.indestructible_item.name[:all] << :fire_axe

    s = RPG::State.new(:rust_aura)
    s.destructible_item.equip_type[:all] << :axe

  end

  def test_equip_type
    g = Game::Enemy.new(:warrior)

    fire      = RPG::Weapon[:fire_axe]
    legendary = RPG::Weapon[:legenary_axe]
    broken    = RPG::Weapon[:broken_axe]

    assert_false(g.item_indestructibly?(fire))
    assert_true(g.item_indestructibly?(legendary))
    assert_false(g.item_indestructibly?(broken))

    g.add_state(:axe_protection)

    assert_true(g.item_indestructibly?(fire))
    assert_true(g.item_indestructibly?(legendary))
    assert_false(g.item_indestructibly?(broken))
      
    g.add_state(:rust_aura)

    assert_false(g.item_indestructibly?(fire))
    assert_false(g.item_indestructibly?(legendary))
    assert_false(g.item_indestructibly?(broken))

  end

  def test_name
    g = Game::Enemy.new(:warrior)

    fire      = RPG::Weapon[:fire_axe]
    legendary = RPG::Weapon[:legenary_axe]
    broken    = RPG::Weapon[:broken_axe]

    assert_false(g.item_indestructibly?(fire))
    assert_true(g.item_indestructibly?(legendary))
    assert_false(g.item_indestructibly?(broken))

    g.add_state(:fireaxe_protection)

    assert_true(g.item_indestructibly?(fire))
    assert_true(g.item_indestructibly?(legendary))
    assert_false(g.item_indestructibly?(broken))

    g.add_state(:rust_aura)

    assert_false(g.item_indestructibly?(fire))
    assert_false(g.item_indestructibly?(legendary))
    assert_false(g.item_indestructibly?(broken))
  end

end