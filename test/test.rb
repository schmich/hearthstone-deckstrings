require 'test/unit'
require 'deckstrings'
 
class TestDeckstrings < Test::Unit::TestCase
  def test_heroes
    assert_not_nil(Deckstrings::Hero.mage)
    assert_not_nil(Deckstrings::Hero.jaina)
    assert_not_nil(Deckstrings::Hero.khadgar)
    assert_not_nil(Deckstrings::Hero.rogue)
    assert_not_nil(Deckstrings::Hero.valeera)
    assert_not_nil(Deckstrings::Hero.maiev)
    assert_not_nil(Deckstrings::Hero.druid)
    assert_not_nil(Deckstrings::Hero.malfurion)
    assert_not_nil(Deckstrings::Hero.shaman)
    assert_not_nil(Deckstrings::Hero.thrall)
    assert_not_nil(Deckstrings::Hero.morgl)
    assert_not_nil(Deckstrings::Hero.priest)
    assert_not_nil(Deckstrings::Hero.anduin)
    assert_not_nil(Deckstrings::Hero.tyrande)
    assert_not_nil(Deckstrings::Hero.hunter)
    assert_not_nil(Deckstrings::Hero.rexxar)
    assert_not_nil(Deckstrings::Hero.alleria)
    assert_not_nil(Deckstrings::Hero.warlock)
    assert_not_nil(Deckstrings::Hero.guldan)
    assert_not_nil(Deckstrings::Hero.paladin)
    assert_not_nil(Deckstrings::Hero.uther)
    assert_not_nil(Deckstrings::Hero.liadrin)
    assert_not_nil(Deckstrings::Hero.arthas)
    assert_not_nil(Deckstrings::Hero.warrior)
    assert_not_nil(Deckstrings::Hero.garrosh)
    assert_not_nil(Deckstrings::Hero.magni)
  end

  def test_hero
    hero = Deckstrings::Hero.jaina
    assert_equal('Jaina Proudmoore', hero.name)
    assert_equal(637, hero.id)
    assert_equal(:mage, hero.hero_class.symbol)
  end

  def test_formats
    assert_not_nil(Deckstrings::Format.wild)
    assert_not_nil(Deckstrings::Format.standard)
  end

  def test_decode
    actual = Deckstrings::decode('AAECAR8GxwPJBLsFmQfZB/gIDI0B2AGoArUDhwSSBe0G6wfbCe0JgQr+DAA=')
    expected = {
      format: 2,
      heroes: [31],
      cards: {
        455 => 1,
        585 => 1,
        699 => 1,
        921 => 1,
        985 => 1,
        1144 => 1,
        141 => 2,
        216 => 2,
        296 => 2,
        437 => 2,
        519 => 2,
        658 => 2,
        877 => 2,
        1003 => 2,
        1243 => 2,
        1261 => 2,
        1281 => 2,
        1662 => 2
      }
    }
    assert_equal(expected, actual)
  end

  def test_encode_simplest
    deck = { format: 0, heroes: [0], cards: { 0 => 1 } }
    actual = Deckstrings::encode(deck)
    expected = 'AAEAAQABAAAA'
    assert_equal(expected, actual)
  end

  def test_encode
    deck = {
      format: 2,
      heroes: [31],
      cards: {
        455 => 1,
        585 => 1,
        699 => 1,
        921 => 1,
        985 => 1,
        1144 => 1,
        141 => 2,
        216 => 2,
        296 => 2,
        437 => 2,
        519 => 2,
        658 => 2,
        877 => 2,
        1003 => 2,
        1243 => 2,
        1261 => 2,
        1281 => 2,
        1662 => 2
      }
    }
    actual = Deckstrings::encode(deck)
    expected = 'AAECAR8GxwPJBLsFmQfZB/gIDI0B2AGoArUDhwSSBe0G6wfbCe0JgQr+DAA='
    assert_equal(expected, actual)
  end
end
