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

  def test_encode_decode_simplest
    deckstring = 'AAEAAAAAAA=='
    deck = { format: 0, heroes: [], cards: { } }
    assert_equal(deck, Deckstrings::decode(deckstring))
    assert_equal(deckstring, Deckstrings::encode(deck))
  end

  def test_encode_missing_argument
    assert_raise(ArgumentError) {
      Deckstrings::encode({ heroes: [0], cards: { 0 => 1 } })
    }
    assert_raise(ArgumentError) {
      Deckstrings::encode({ format: 0, cards: { 0 => 1 } })
    }
    assert_raise(ArgumentError) {
      Deckstrings::encode({ format: 0, heroes: [0] })
    }
  end

  def test_encode_zero_count
    assert_raise(ArgumentError) {
      Deckstrings::encode({ format: 0, heroes: [0], cards: { 0 => 0 } })
    }
  end

  def test_decode_missing_deckstring
    assert_raise(ArgumentError) {
      Deckstrings::decode(nil)
    }
    assert_raise(ArgumentError) {
      Deckstrings::decode('')
    }
  end

  def test_encode_decode
    deckstring = 'AAECAR8GxwPJBLsFmQfZB/gIDI0B2AGoArUDhwSSBe0G6wfbCe0JgQr+DAA='
    deck = { format: 2, heroes: [31], cards: { 455 => 1, 585 => 1, 699 => 1, 921 => 1, 985 => 1, 1144 => 1, 141 => 2, 216 => 2, 296 => 2, 437 => 2, 519 => 2, 658 => 2, 877 => 2, 1003 => 2, 1243 => 2, 1261 => 2, 1281 => 2, 1662 => 2 } }
    assert_equal(deck, Deckstrings::decode(deckstring))
    assert_equal(deckstring, Deckstrings::encode(deck))
  end
end
