# Hearthstone Deckstrings

Ruby library for encoding and decoding [Hearthstone deckstrings](https://hearthsim.info/docs/deckstrings/).

## Getting Started

```bash
gem install deckstrings
```

```ruby
require 'deckstrings'
```

## Decoding

For the simplest decoding with the least validation, use `Deckstrings::decode`:

```ruby
deckstring = 'AAECAZICCPIF+Az5DK6rAuC7ApS9AsnHApnTAgtAX/4BxAbkCLS7Asu8As+8At2+AqDNAofOAgA='
puts Deckstrings::decode(deckstring)
```

Output:

```text
{:format=>2, :heroes=>[274], :cards=>{754=>1, 1656=>1, 1657=>1, 38318=>1, 40416=>1, 40596=>1, 41929=>1, 43417=>1, 64=>2, 95=>2, 254=>2, 836=>2, 1124=>2, 40372=>2, 40523=>2, 40527=>2, 40797=>2, 42656=>2, 42759=>2}}
```

For extended validation and additional information, use `Deckstrings::Deck.parse`:

```ruby
deckstring = 'AAECAZICCPIF+Az5DK6rAuC7ApS9AsnHApnTAgtAX/4BxAbkCLS7Asu8As+8At2+AqDNAofOAgA='
puts Deckstrings::Deck.parse(deckstring)
```

Output:

```text
Format: Standard
Hero: Malfurion Stormrage (Druid)
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


## License

Copyright &copy; 2017 Chris Schmich  
MIT License. See [LICENSE](LICENSE) for details.
