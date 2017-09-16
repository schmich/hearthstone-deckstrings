require 'test/unit'
require 'deckstrings'

class TestDeckstrings < Test::Unit::TestCase
  def test_heroes
    heroes = [
      Deckstrings::Hero.mage,
      Deckstrings::Hero.jaina,
      Deckstrings::Hero.khadgar,
      Deckstrings::Hero.rogue,
      Deckstrings::Hero.valeera,
      Deckstrings::Hero.maiev,
      Deckstrings::Hero.druid,
      Deckstrings::Hero.malfurion,
      Deckstrings::Hero.shaman,
      Deckstrings::Hero.thrall,
      Deckstrings::Hero.morgl,
      Deckstrings::Hero.priest,
      Deckstrings::Hero.anduin,
      Deckstrings::Hero.tyrande,
      Deckstrings::Hero.hunter,
      Deckstrings::Hero.rexxar,
      Deckstrings::Hero.alleria,
      Deckstrings::Hero.warlock,
      Deckstrings::Hero.guldan,
      Deckstrings::Hero.paladin,
      Deckstrings::Hero.uther,
      Deckstrings::Hero.liadrin,
      Deckstrings::Hero.arthas,
      Deckstrings::Hero.warrior,
      Deckstrings::Hero.garrosh,
      Deckstrings::Hero.magni
    ]
    heroes.each do |hero|
      assert_not_nil(hero)
      parts = Deckstrings::decode(Deckstrings::encode(format: 0, heroes: [hero], cards: {}))
      assert_equal(hero.id, parts[:heroes].first)
    end
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

  def test_encode_decode
    deckstring = 'AAECAR8GxwPJBLsFmQfZB/gIDI0B2AGoArUDhwSSBe0G6wfbCe0JgQr+DAA='
    deck = { format: 2, heroes: [31], cards: { 455 => 1, 585 => 1, 699 => 1, 921 => 1, 985 => 1, 1144 => 1, 141 => 2, 216 => 2, 296 => 2, 437 => 2, 519 => 2, 658 => 2, 877 => 2, 1003 => 2, 1243 => 2, 1261 => 2, 1281 => 2, 1662 => 2 } }
    assert_equal(deck, Deckstrings::decode(deckstring))
    assert_equal(deckstring, Deckstrings::encode(deck))
  end

  def test_encode_format_enum
    assert_equal(
      Deckstrings::encode(format: 1, heroes: [], cards: {}),
      Deckstrings::encode(format: Deckstrings::Format.wild, heroes: [], cards: {})
    )
  end

  def test_encode_hero_object
    assert_equal(
      Deckstrings::encode(format: 0, heroes: [7], cards: {}),
      Deckstrings::encode(format: 0, heroes: [Deckstrings::Hero.garrosh], cards: {})
    )
  end

  def test_hero_sort
    assert_equal(
      Deckstrings::encode(format: 0, heroes: [0, 1], cards: {}),
      Deckstrings::encode(format: 0, heroes: [1, 0], cards: {})
    )
  end

  def test_card_sort
    assert_equal(
      Deckstrings::encode(format: 0, heroes: [], cards: { 0 => 1, 1 => 1 }),
      Deckstrings::encode(format: 0, heroes: [], cards: { 1 => 1, 0 => 1 })
    )
    assert_equal(
      Deckstrings::encode(format: 0, heroes: [], cards: { 0 => 1, 1 => 1, 2 => 2, 3 => 2, 4 => 3 }),
      Deckstrings::encode(format: 0, heroes: [], cards: { 3 => 2, 4 => 3, 1 => 1, 0 => 1, 2 => 2 })
    )
  end

  def test_encode_missing_argument
    assert_raise(ArgumentError) {
      Deckstrings::encode(heroes: [0], cards: { 0 => 1 })
    }
    assert_raise(ArgumentError) {
      Deckstrings::encode(format: 0, cards: { 0 => 1 })
    }
    assert_raise(ArgumentError) {
      Deckstrings::encode(format: 0, heroes: [0])
    }
  end

  def test_encode_invalid_count
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::encode(format: 0, heroes: [], cards: { 0 => 0 })
    }
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::encode(format: 0, heroes: [], cards: { 0 => -5 })
    }
  end

  def test_decode_missing_deckstring
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::decode(nil)
    }
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::decode('')
    }
  end

  def test_decode_invalid_base64
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::decode("{}''\n\t @$%^&*()")
    }
  end

  def test_decode_invalid_reserved
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::decode('BB')
    }
  end

  def test_decode_invalid_version
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::decode('AABB')
    }
  end

  def test_decode_unexpected_eof
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::decode('AAEB0')
    }
  end

  def test_format_query
    wild = Deckstrings::encode(format: Deckstrings::Format.wild, heroes: [], cards: {})
    assert_equal(true, Deckstrings::Deck.decode(wild).wild?)
    standard = Deckstrings::encode(format: Deckstrings::Format.standard, heroes: [], cards: {})
    assert_equal(true, Deckstrings::Deck.decode(standard).standard?)
  end

  def test_deck_invalid_argument
    assert_raise(ArgumentError) {
      Deckstrings::Deck.new(format: 10, heroes: [], cards: {})
    }
    assert_raise(ArgumentError) {
      Deckstrings::Deck.new(format: 1, heroes: [-1], cards: {})
    }
    assert_raise(ArgumentError) {
      Deckstrings::Deck.new(format: 1, heroes: [], cards: { -1 => 1 })
    }
  end

  def test_deck_decode_invalid
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::Deck.decode(Deckstrings::encode({ format: 100, heroes: [], cards: {} }))
    }
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::Deck.decode(Deckstrings::encode({ format: 1, heroes: [100], cards: {} }))
    }
    assert_raise(Deckstrings::FormatError) {
      Deckstrings::Deck.decode(Deckstrings::encode({ format: 1, heroes: [], cards: { 9999999 => 1 } }))
    }
  end

  def test_deckstrings
    deckstrings = [
      'AAEBAf0GAA/yAaIC3ALgBPcE+wWKBs4H2QexCMII2Q31DfoN9g4A',
      'AAECAZICCPIF+Az5DK6rAuC7ApS9AsnHApnTAgtAX/4BxAbkCLS7Asu8As+8At2+AqDNAofOAgA=',
      'AAECAaIHCLIC7QLdCJG8Asm/ApTQApziAp7iAgu0AagF1AXcrwKStgKBwgKbwgLrwgLKywKmzgKnzgIA',
      'AAECAR8E8gXtCZG8AobTAg2oArUD5QfrB5cIxQj+DLm0Auq7AuTCAo7DAtPNAtfNAgA=',
      'AAECAQcES+0FoM4Cn9MCDZAD/ASRBvgH/weyCPsMxsMC38QCzM0Cjs4Cns4C8dMCAA==',
      'AAECAf0GHjCKAZMB9wTtBfIF2waSB7YH4Qf7B40IxAjMCPMM2LsC2bwC3bwCysMC3sQC38QC08UC58sCos0C980Cn84CoM4Cws4Cl9MCl+gCAAA=',
      'AAECAZ8FDPIF9QX6Bo8JvL0C/70CucEC78ICps4Cws4CnOIC0OICCdmuArO7ApW8ApvCAsrDAuPLAqfOAvfQApboAgA=',
      'AAECAZICCEDyBfkMrqsC4LsClL0Cz8cCmdMCC1+KAf4B3gXEBuQIvq4CtLsCy7wCoM0Ch84CAA==',
      'AAEBAaIHCLIC9gTUBe0FpAeQEJG8AoHCAgu0AcsDzQObBbkGiAfdCIYJrxDEFpK2AgA=',
      'AAEBAZ8FCqcF4AX6BusPnhCEF9muArq9AuO+ArnBAgrbA6cI6g/TqgLTvAKzwQKdwgKxwgKIxwLjywIA',
      'AAEBAf0EArgI1hEOigHAAZwCyQOrBMsE5gTtBJYF+Af3DZjEAtrFArnRAgA=',
      'AAEBAa0GBgm0A5IPtxeoqwKFuAIMlwKhBNMK1wr6EaGsAui/AtHBAuXMAubMArTOAvDPAgA=',
      'AAEBAf0GCLYH+g7CD/UP8BHdvAL3zQKX0wILigGTAdMB4QeNCNwKjg6tEN4Wqa0C58sCAA==',
      'AAEBAZICCrQDxQTtBbkGig7WEegV7BWuqwLguwIKQF/+AdMDxAbkCJdovq4CoM0Ch84CAA==',
      'AAEBAQcG+QzVEbAVxsMCoM4C9s8CDEuRA9QEkQb4B/8H+wzkD4KtAszNAo7OAvHTAgA=',
      'AAEBAR8C/gyG0wIO0wG1A4cEgAfhB5cIxQjcCvcNuRHUEcsU3hbTzQIA',
      'AAECAR8CuwXFCA6oArUD6weXCNsJ7QmBCv4Mzq4C6rsC5MICjsMC080Cps4CAA==',
      'AAECAaoIBNAHiq0C9r0Cm8ICDVrvAYECgQT+BfAHkwn3qgL6qgL1rALDtAKuvAL5vwIA',
      'AAECAf0GBPcEoQaxCMUJDTDcAvUF+wXZB8IIxAi0rAL2rgLnwQKrwgLrwgKVzgIA',
      'AAECAZICCNUB/gHTAosE+wTjBdoK+QoLKUBa2AGBAqECtALgBOYFngnZCgA=',
      'AAECAQcAAZEDAA==',
      'AAECAf0EBk20AvEFigfsB5YNDCla2AG7AoUDiwOrBLQElgWABrwI2QoA',
      'AAECAZ8FAkaeCQ6EAfoBgQKhAoUDvQPcA+4EiAXjBc8GrwfQB/UMAA==',
      'AAEBAa0GAA/lBJ0GyQalCdIK0wrXCvIM8wyFEJYUiq0C7K4C0sECm8ICAA=='
    ]
    deckstrings.each do |deckstring|
      deck = Deckstrings::Deck.decode(deckstring)
      decode = Deckstrings::decode(deckstring)
      assert_equal(deck.raw, decode)
      assert_equal(deckstring, Deckstrings::encode(deck.raw))
      assert_equal(deckstring, Deckstrings::encode(decode))
      assert_equal(deckstring, deck.deckstring)
    end
  end
end
