# Hearthstone Deckstrings [![Gem Version](https://badge.fury.io/rb/deckstrings.svg)](http://rubygems.org/gems/deckstrings) [![Build Status](https://travis-ci.org/schmich/hearthstone-deckstrings.svg?branch=master)](https://travis-ci.org/schmich/hearthstone-deckstrings)

Ruby library for encoding and decoding [Hearthstone deckstrings](https://hearthsim.info/docs/deckstrings/). See [documentation](http://www.rubydoc.info/gems/deckstrings) for help.

## Usage

```bash
gem install deckstrings
```

```ruby
require 'deckstrings'
```

Hearthstone deckstrings encode a Hearthstone deck in a compact format.

The IDs used in deckstrings and in this library refer to Hearthstone DBF IDs which uniquely define Hearthstone entities like cards and heroes.

For additional entity metadata (e.g. hero class, card cost, card name), the DBF IDs can be used in conjunction with the [HearthstoneJSON](https://hearthstonejson.com/) database.

## Decoding

`Deckstrings::decode` provides the simplest decoding with the least validation.

```ruby
deckstring = 'AAECAZICCPIF+Az5DK6rAuC7ApS9AsnHApnTAgtAX/4BxAbkCLS7Asu8As+8At2+AqDNAofOAgA='
puts Deckstrings::decode(deckstring)
```

```text
{:format=>2, :heroes=>[274], :cards=>{754=>1, 1656=>1, 1657=>1, 38318=>1, 40416=>1, 40596=>1, 41929=>1, 43417=>1, 64=>2, 95=>2, 254=>2, 836=>2, 1124=>2, 40372=>2, 40523=>2, 40527=>2, 40797=>2, 42656=>2, 42759=>2}}
```

`Deckstrings::Deck.parse` provides extended validation and additional deck information including card name and cost.

```ruby
deckstring = 'AAECAZICCPIF+Az5DK6rAuC7ApS9AsnHApnTAgtAX/4BxAbkCLS7Asu8As+8At2+AqDNAofOAgA='
puts Deckstrings::Deck.parse(deckstring)
```

```text
Format: Standard
Class: Druid
Hero: Malfurion Stormrage

2× Innervate
2× Jade Idol
2× Wild Growth
2× Wrath
2× Jade Blossom
2× Swipe
2× Jade Spirit
1× Fandral Staghelm
1× Spellbreaker
2× Nourish
1× Big Game Hunter
2× Spreading Plague
1× The Black Knight
1× Aya Blackpaw
2× Jade Behemoth
1× Malfurion the Pestilent
1× Primordial Drake
2× Ultimate Infestation
1× Kun the Forgotten King
```

## Encoding

`Deckstrings::encode`

`Deckstrings::Deck`

## License

Copyright &copy; 2017 Chris Schmich  
MIT License. See [LICENSE](LICENSE) for details.
