require 'base64'
require 'json'

module Deckstrings
  class FormatError < StandardError
    def initialize(message)
      super(message)
    end
  end

  class Format
    include Enum
    define :wild, 1, 'Wild'
    define :standard, 2, 'Standard'
  end

  class HeroClass
    include Enum
    define :mage, 'mage', 'Mage'
    define :rogue, 'rogue', 'Rogue'
    define :druid, 'druid', 'Druid'
    define :hunter, 'hunter', 'Hunter'
    define :shaman, 'shaman', 'Shaman'
    define :priest, 'priest', 'Priest'
    define :warrior, 'warrior', 'Warrior'
    define :paladin, 'paladin', 'Paladin'
    define :warlock, 'warlock', 'Warlock'
  end

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

  class Hero
    def initialize(id, name, hero_class)
      @id = id
      @name = name
      @hero_class = HeroClass.parse(hero_class)
    end

    def self.mage
      self.jaina
    end

    def self.jaina
      self.from_id(637)
    end

    def self.khadgar
      self.from_id(39117)
    end

    def self.rogue
      self.valeera
    end

    def self.valeera
      self.from_id(930)
    end

    def self.maiev
      self.from_id(40195)
    end

    def self.druid
      self.malfurion
    end

    def self.malfurion
      self.from_id(274)
    end

    def self.shaman
      self.thrall
    end

    def self.thrall
      self.from_id(1066)
    end

    def self.morgl
      self.from_id(40183)
    end

    def self.priest
      self.anduin
    end

    def self.anduin
      self.from_id(813)
    end

    def self.tyrande
      self.from_id(41887)
    end

    def self.hunter
      self.rexxar
    end

    def self.rexxar
      self.from_id(31)
    end

    def self.alleria
      self.from_id(2826)
    end

    def self.warlock
      self.guldan
    end

    def self.guldan
      self.from_id(893)
    end

    def self.paladin
      self.uther
    end

    def self.uther
      self.from_id(671)
    end

    def self.liadrin
      self.from_id(2827)
    end

    def self.arthas
      self.from_id(46116)
    end

    def self.warrior
      self.garrosh
    end

    def self.garrosh
      self.from_id(7)
    end

    def self.magni
      self.from_id(2828)
    end

    def self.from_id(id)
      heroes = Database.instance.heroes
      hero = heroes[id]
      Hero.new(id, hero['name'], hero['class'])
    end

    attr_reader :id, :name, :hero_class
  end

  class Card
    def initialize(id, name, cost)
      @id = id
      @name = name
      @cost = cost
    end

    attr_accessor :id, :name, :cost
  end

  class Deck
    def initialize(format:, heroes:, cards:)
      # TODO: Translate RangeError -> FormatError.

      @format = Format.parse(format) if !format.is_a?(Format)
      if !@format
        raise FormatError.new("Unknown format: #{format}.")
      end

      @heroes = heroes.map do |id|
        hero = Database.instance.heroes[id]
        raise FormatError.new("Unknown hero: #{id}.") if hero.nil?
        Hero.new(id, hero['name'], hero['class'])
      end

      @cards = cards.map do |id, count|
        card = Database.instance.cards[id]
        raise FormatError.new("Unknown card: #{id}.") if card.nil?
        [Card.new(id, card['name'], card['cost']), count]
      end.sort_by { |card, _| card.cost }.to_h
    end

    def raw
      heroes = @heroes.map(&:id)
      cards = @cards.map { |card, count| [card.id, count] }.to_h
      { format: @format.value, heroes: heroes, cards: cards }
    end

    def deckstring
      return Deckstrings::encode(self.raw)
    end

    def self.parse(deckstring)
      parts = Deckstrings::decode(deckstring)
      Deck.new(parts)
    end

    def wild?
      format == Format.wild
    end

    def standard?
      format == Format.standard
    end

    def to_s
      hero = @heroes.first
      "Format: #{format}\nHero: #{hero.name} (#{hero.hero_class})\n" + cards.map do |card, count|
        "#{count}× #{card.name}"
      end.join("\n")
    end

    attr_reader :format, :heroes, :cards
  end

  using VarIntExtensions

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
      raise ArgumentError.new("Invalid card count: #{invalid.join(', ')}.")
    end

    1.upto(3) do |count|
      group = by_count[count] || []
      stream.write_varint(group.length)
      group.sort_by { |id, n| id }.each do |id, n|
        stream.write_varint(id)
        stream.write_varint(n) if n > 2
      end
    end

    Base64::encode64(stream.string).strip
  end

  def self.decode(deckstring)
    # TODO: Translate EOFError -> FormatError.

    if deckstring.nil? || deckstring.empty?
      raise ArgumentError.new('Invalid deckstring.')
    end

    stream = StringIO.new(Base64::decode64(deckstring))

    reserved = stream.read_varint
    if reserved != 0
      raise FormatError.new("Unexpected reserved byte: #{reserved}.")
    end

    version = stream.read_varint
    if version != 1
      raise FormatError.new("Unexpected version: #{version}.")
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

    return {
      format: format,
      heroes: heroes,
      cards: cards
    }
  end
end
