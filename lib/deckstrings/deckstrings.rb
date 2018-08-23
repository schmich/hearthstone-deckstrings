require 'base64'
require 'json'

module Deckstrings
  # An error indicating a malformed deckstring.
  class FormatError < StandardError
  end

  # Enumeration of valid format types: wild and standard.
  class Format
    include Enum

    # @!scope class
    # @return [Format] Wild format.
    define :wild, 1, 'Wild'

    # @!scope class
    # @return [Format] Standard format.
    define :standard, 2, 'Standard'
  end

  # Enumeration of all nine Hearthstone classes.
  class HeroClass
    include Enum

    # @!scope class
    # @return [HeroClass] Mage class.
    define :mage, 'mage', 'Mage'

    # @!scope class
    # @return [HeroClass] Rogue class.
    define :rogue, 'rogue', 'Rogue'

    # @!scope class
    # @return [HeroClass] Druid class.
    define :druid, 'druid', 'Druid'

    # @!scope class
    # @return [HeroClass] Hunter class.
    define :hunter, 'hunter', 'Hunter'

    # @!scope class
    # @return [HeroClass] Shaman class.
    define :shaman, 'shaman', 'Shaman'

    # @!scope class
    # @return [HeroClass] Priest class.
    define :priest, 'priest', 'Priest'

    # @!scope class
    # @return [HeroClass] Warrior class.
    define :warrior, 'warrior', 'Warrior'

    # @!scope class
    # @return [HeroClass] Paladin class.
    define :paladin, 'paladin', 'Paladin'

    # @!scope class
    # @return [HeroClass] Warlock class.
    define :warlock, 'warlock', 'Warlock'
  end

  # @private
  class Database
    def initialize
      file = File.expand_path('database.json', File.dirname(__FILE__))
      @database = JSON.parse(File.read(file))
    end

    def self.instance
      @@instance ||= Database.new
    end

    def cards
      @cards ||= begin
        @database['cards'].map { |k, v| [k.to_i, v] }.to_h
      end
    end

    def heroes
      @heroes ||= begin
        @database['heroes'].map { |k, v| [k.to_i, v] }.to_h
      end
    end
  end

  # A Hearthstone hero with basic metadata.
  # @see Deck#heroes
  class Hero
    def initialize(id, name, hero_class)
      @id = id
      @name = name
      @hero_class = HeroClass.parse(hero_class)
      raise ArgumentError, "Invalid hero class: #{hero_class}." if @hero_class.nil?
    end

    # @return [Hero] Jaina Proudmoore.
    def self.mage
      self.jaina
    end

    # @return [Hero] Jaina Proudmoore.
    def self.jaina
      self.from_id(637)
    end

    # @return [Hero] Khadgar.
    def self.khadgar
      self.from_id(39117)
    end

    # @return [Hero] Valeera Sanguinar.
    def self.rogue
      self.valeera
    end

    # @return [Hero] Valeera Sanguinar.
    def self.valeera
      self.from_id(930)
    end

    # @return [Hero] Maiev Shadowsong.
    def self.maiev
      self.from_id(40195)
    end

    # @return [Hero] Malfurion Stormrage.
    def self.druid
      self.malfurion
    end

    # @return [Hero] Malfurion Stormrage.
    def self.malfurion
      self.from_id(274)
    end

    # @return [Hero] Lunara.
    def self.lunara
      self.from_id(50484)
    end

    # @return [Hero] Thrall.
    def self.shaman
      self.thrall
    end

    # @return [Hero] Thrall.
    def self.thrall
      self.from_id(1066)
    end

    # @return [Hero] Morgl the Oracle.
    def self.morgl
      self.from_id(40183)
    end

    # @return [Hero] Anduin Wrynn.
    def self.priest
      self.anduin
    end

    # @return [Hero] Anduin Wrynn.
    def self.anduin
      self.from_id(813)
    end

    # @return [Hero] Tyrande Whisperwind.
    def self.tyrande
      self.from_id(41887)
    end

    # @return [Hero] Rexxar.
    def self.hunter
      self.rexxar
    end

    # @return [Hero] Rexxar.
    def self.rexxar
      self.from_id(31)
    end

    # @return [Hero] Alleria Windrunner.
    def self.alleria
      self.from_id(2826)
    end

    # @return [Hero] Gul'dan.
    def self.warlock
      self.guldan
    end

    # @return [Hero] Gul'dan.
    def self.guldan
      self.from_id(893)
    end

    # @return [Hero] Nemsy Necrofizzle.
    def self.nemsy
      self.from_id(47817)
    end

    # @return [Hero] Mecha-Jaraxxus.
    def self.mecha_jaraxxus
      self.from_id(51834)
    end

    # @return [Hero] Uther Lightbringer.
    def self.paladin
      self.uther
    end

    # @return [Hero] Uther Lightbringer.
    def self.uther
      self.from_id(671)
    end

    # @return [Hero] Lady Liadrin.
    def self.liadrin
      self.from_id(2827)
    end

    # @return [Hero] Prince Arthas.
    def self.arthas
      self.from_id(46116)
    end

    # @return [Hero] Garrosh Hellscream.
    def self.warrior
      self.garrosh
    end

    # @return [Hero] Garrosh Hellscream.
    def self.garrosh
      self.from_id(7)
    end

    # @return [Hero] Magni Bronzebeard.
    def self.magni
      self.from_id(2828)
    end

    # @param id [Integer] Hero's Hearthstone DBF ID.
    # @return [Hero] Hero corresponding to DBF ID.
    def self.from_id(id)
      hero = Database.instance.heroes[id]
      Hero.new(id, hero['name'], hero['class'])
    end

    # @return [Integer] Hearthstone DBF ID of the hero.
    # @see https://hearthstonejson.com/ HearthstoneJSON
    attr_reader :id

    # @return [String] Name of the hero.
    attr_reader :name

    # @return [HeroClass] Class of the hero.
    attr_reader :hero_class
  end

  # A Hearthstone card with basic metadata.
  # @see Deck.decode
  class Card
    def initialize(id, name, cost)
      @id = id
      @name = name
      @cost = cost
    end

    # @return [Integer] Hearthstone DBF ID of the card.
    # @see https://hearthstonejson.com/ HearthstoneJSON
    attr_reader :id

    # @return [String] Name of the card.
    attr_reader :name

    # @return [Integer] Mana cost of the card.
    attr_reader :cost
  end

  # A Hearthstone deck with metadata that is convertible to and from a deckstring.
  # @see Deck.decode
  # @see Deck.encode
  class Deck
    # Create a new deck from component parts.
    # @param format [Integer, Deckstrings::Format] Format for this deck: wild or standard.
    # @param heroes [Array<Integer, Deckstrings::Hero>] Heroes for this deck. Multiple heroes are supported, but typically
    #   this array will contain one element.
    # @param cards [Hash{Integer, Deckstrings::Card => Integer}] Cards in the deck. A Hash from card ID to its instance count in the deck.
    # @raise [ArgumentError] If format, heroes, or any cards are unknown.
    def initialize(format:, heroes:, cards:)
      @format = Format.parse(format) if !format.is_a?(Format)
      raise ArgumentError, "Unknown format: #{format}." if !@format

      @heroes = heroes.map do |id|
        hero = Database.instance.heroes[id]
        raise ArgumentError, "Unknown hero: #{id}." if hero.nil?
        Hero.new(id, hero['name'], hero['class'])
      end

      @cards = cards.map do |id, count|
        card = Database.instance.cards[id]
        raise ArgumentError, "Unknown card: #{id}." if card.nil?
        [Card.new(id, card['name'], card['cost']), count]
      end.sort_by { |card, _| card.cost }.to_h
    end

    # Raw deck details.
    # @return [{ format: Integer, heroes: Array<Integer>, cards: Hash{Integer => Integer} }] See {Deckstrings.decode} for details.
    # @see Deckstrings.decode
    def raw
      heroes = @heroes.map(&:id)
      cards = @cards.map { |card, count| [card.id, count] }.to_h
      { format: @format.value, heroes: heroes, cards: cards }
    end

    # Encoded deckstring for this deck.
    # @return [String] Base64-encoded compact byte string representing the deck.
    # @see Deckstrings.encode
    # @see .encode
    def deckstring
      return Deckstrings::encode(self.raw)
    end

    # Decodes a Hearthstone deckstring into a {Deck} with basic hero and card metadata.
    #
    # This method validates the well-formedness of the deckstring, the embedded version, the format, card counts, and
    # each hero/card ID.
    #
    # All IDs refer to unique Hearthstone DBF IDs which can be used in conjunction with [HearthstoneJSON metadata](https://hearthstonejson.com/).
    # @example
    #   deck = Deckstrings::Deck.decode('AAEBAf0GAA/yAaIC3ALgBPcE+wWKBs4H2QexCMII2Q31DfoN9g4A')
    # @example
    #   deck = Deckstrings::Deck.decode('AAECAZICCPIF+Az5DK6rAuC7ApS9AsnHApnTAgtAX/4BxAbkCLS7Asu8As+8At2+AqDNAofOAgA=')
    # @param deckstring [String] Base64-encoded Hearthstone deckstring.
    # @raise [FormatError] If the deckstring is malformed or contains invalid deck data.
    # @return [Deck] Decoded Hearthstone deck.
    # @see Deckstrings.decode
    # @see Deck.encode
    # @see https://hearthstonejson.com/ HearthstoneJSON
    def self.decode(deckstring)
      parts = Deckstrings::decode(deckstring)
      begin
        Deck.new(parts)
      rescue ArgumentError => e
        raise FormatError, e.to_s
      end
    end

    # Encodes a Hearthstone deck as a compact deckstring.
    #
    # This method validates card counts, format, and each hero/card ID.
    #
    # All IDs refer to unique Hearthstone DBF IDs which can be seen in [HearthstoneJSON metadata](https://hearthstonejson.com/).
    # @example
    #   deckstring = Deckstrings::Deck.encode(format: 2, heroes: [637], cards: { 1004 => 2, 315 => 2 })
    # @example
    #   deckstring = Deckstrings::Deck.encode(
    #     format: Deckstrings::Format.standard,
    #     heroes: [Deckstrings::Hero.mage],
    #     cards: { 1004 => 2, 315 => 2 }
    #   )
    # @param format [Integer, Deckstrings::Format] Format for this deck: wild or standard.
    # @param heroes [Array<Integer, Deckstrings::Hero>] Heroes for this deck. Multiple heroes are supported, but typically
    #   this array will contain one element.
    # @param cards [Hash{Integer, Deckstrings::Card => Integer}] Cards in the deck. A Hash from card ID to its instance count in the deck.
    # @raise [FormatError] If any card counts are less than 1, or if any IDs do not refer to valid Hearthstone entities.
    # @return [String] Base64-encoded compact byte string representing the deck.
    # @see .encode
    # @see Deck.decode
    # @see https://hearthstonejson.com/ HearthstoneJSON
    def self.encode(format:, heroes:, cards:)
      begin
        Deck.new(format: format, heroes: heroes, cards: cards).deckstring
      rescue ArgumentError => e
        raise FormatError, e.to_s
      end
    end

    # @return [Boolean] `true` if the deck is Wild format, `false` otherwise.
    # @see #standard?
    def wild?
      format.wild?
    end

    # @return [Boolean] `true` if the deck is Standard format, `false` otherwise.
    # @see #wild?
    def standard?
      format.standard?
    end

    # Pretty-printed deck listing.
    # @example
    #   puts Deckstrings::Deck.decode('AAECAZICCPIF+Az5DK6rAuC7ApS9AsnHApnTAgtAX/4BxAbkCLS7Asu8As+8At2+AqDNAofOAgA=')
    # @example
    #   Format: Standard
    #   Class: Druid
    #   Hero: Malfurion Stormrage
    #
    #   2× Innervate
    #   2× Jade Idol
    #   2× Wild Growth
    #   2× Wrath
    #   2× Jade Blossom
    #   2× Swipe
    #   2× Jade Spirit
    #   1× Fandral Staghelm
    #   1× Spellbreaker
    #   2× Nourish
    #   1× Big Game Hunter
    #   2× Spreading Plague
    #   1× The Black Knight
    #   1× Aya Blackpaw
    #   2× Jade Behemoth
    #   1× Malfurion the Pestilent
    #   1× Primordial Drake
    #   2× Ultimate Infestation
    #   1× Kun the Forgotten King
    # @return [String] A pretty-printed listing of deck details.
    def to_s
      listing = "Format: #{format}"

      hero = @heroes.first
      if hero
        listing += "\nClass: #{hero.hero_class}\nHero: #{hero.name}"
      end

      if !cards.empty?
        listing += "\n\n" + cards.map { |card, count| "#{count}× #{card.name}" }.join("\n")
      end

      listing
    end

    # @return [Format] Format for this deck.
    attr_reader :format

    # The heroes associated with this deck.
    # @return [Array<Hero>] Typically, this array will contain one element.
    attr_reader :heroes

    # The cards contained in this deck.
    # @return [Hash{Card => Integer}] A Hash from {Card} to its instance count in the deck.
    attr_reader :cards
  end

  using VarIntExtensions

  # Encodes a Hearthstone deck as a compact deckstring.
  #
  # This method validates card counts, but does not validate the format or individual hero/card IDs. For stricter validation,
  # see {Deck.encode}.
  #
  # All IDs refer to unique Hearthstone DBF IDs which can be seen in [HearthstoneJSON metadata](https://hearthstonejson.com/).
  # @example
  #   deckstring = Deckstrings::encode(format: 2, heroes: [637], cards: { 1004 => 2, 315 => 2 })
  # @example
  #   deckstring = Deckstrings::encode(
  #     format: Deckstrings::Format.standard,
  #     heroes: [Deckstrings::Hero.mage],
  #     cards: { 1004 => 2, 315 => 2 }
  #   )
  # @param format [Integer, Deckstrings::Format] Format for this deck: wild or standard.
  # @param heroes [Array<Integer, Deckstrings::Hero>] Heroes for this deck. Multiple heroes are supported, but typically
  #   this array will contain one element.
  # @param cards [Hash{Integer, Deckstrings::Card => Integer}] Cards in the deck. A Hash from card ID to its instance count in the deck.
  # @raise [FormatError] If any card counts are less than 1.
  # @return [String] Base64-encoded compact byte string representing the deck.
  # @see Deck.encode
  # @see .decode
  # @see https://hearthstonejson.com/ HearthstoneJSON
  def self.encode(format:, heroes:, cards:)
    stream = StringIO.new('')

    format = format.is_a?(Deckstrings::Format) ? format.value : format
    heroes = heroes.map { |hero| hero.is_a?(Deckstrings::Hero) ? hero.id : hero }

    # Reserved slot, version, and format.
    stream.write_varint(0)
    stream.write_varint(1)
    stream.write_varint(format)

    # Heroes.
    stream.write_varint(heroes.length)
    heroes.sort.each do |hero|
      stream.write_varint(hero)
    end

    # Cards.
    by_count = cards.group_by { |id, n| n > 2 ? 3 : n }

    invalid = by_count.keys.select { |count| count < 1 }
    unless invalid.empty?
      raise FormatError, "Invalid card count: #{invalid.join(', ')}."
    end

    1.upto(3) do |count|
      group = by_count[count] || []
      stream.write_varint(group.length)
      group.sort_by { |id, n| id }.each do |id, n|
        stream.write_varint(id)
        stream.write_varint(n) if n > 2
      end
    end

    Base64::strict_encode64(stream.string).strip
  end

  # Decodes a Hearthstone deckstring into format, hero, and card counts.
  #
  # This method validates the well-formedness of the deckstring and the embedded version, but does not validate
  # the format, individual hero/card IDs, or card counts. For stricter validation and additional deck info, see {Deck.decode}.
  #
  # All IDs refer to unique Hearthstone DBF IDs which can be used in conjunction with [HearthstoneJSON metadata](https://hearthstonejson.com/).
  # @example
  #   deck = Deckstrings::decode('AAEBAf0GAA/yAaIC3ALgBPcE+wWKBs4H2QexCMII2Q31DfoN9g4A')
  # @example
  #   deck = Deckstrings::decode('AAECAZICCPIF+Az5DK6rAuC7ApS9AsnHApnTAgtAX/4BxAbkCLS7Asu8As+8At2+AqDNAofOAgA=')
  # @param deckstring [String] Base64-encoded Hearthstone deckstring.
  # @raise [FormatError] If the deckstring is malformed or contains invalid deck data.
  # @return [{ format: Integer, heroes: Array<Integer>, cards: Hash{Integer => Integer} }] Parsed Hearthstone deck details.
  #   `heroes` is an array of hero IDs, but this will usually be just one element. `cards` is a
  #   Hash from card ID to its instance count in the deck.
  # @see Deck.decode
  # @see .encode
  # @see https://hearthstonejson.com/ HearthstoneJSON
  def self.decode(deckstring)
    if deckstring.nil? || deckstring.empty?
      raise FormatError, 'Invalid deckstring.'
    end

    stream = begin
      StringIO.new(Base64::strict_decode64(deckstring))
    rescue ArgumentError
      raise FormatError, 'Invalid base64-encoded string.'
    end

    begin
      reserved = stream.read_varint
      if reserved != 0
        raise FormatError, "Unexpected reserved byte: #{reserved}."
      end

      version = stream.read_varint
      if version != 1
        raise FormatError, "Unexpected version: #{version}."
      end

      format = stream.read_varint

      # Heroes
      heroes = []
      length = stream.read_varint
      length.times do
        heroes << stream.read_varint
      end

      # Cards
      cards = {}
      1.upto(3) do |i|
        length = stream.read_varint
        length.times do
          card = stream.read_varint
          cards[card] = i < 3 ? i : stream.read_varint
        end
      end
    rescue EOFError
      raise FormatError, 'Unexpected end of data.'
    end

    return {
      format: format,
      heroes: heroes,
      cards: cards
    }
  end
end
