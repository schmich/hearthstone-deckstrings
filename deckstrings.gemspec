require File.expand_path('lib/deckstrings/version.rb', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = 'deckstrings'
  s.version = Deckstrings::VERSION
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'Encode and decode Hearthstone deckstrings.'
  s.description = 'Ruby library for encoding and decoding Hearthstone deckstrings.'
  s.authors = ['Chris Schmich']
  s.email = 'schmch@gmail.com'
  s.files = Dir['{lib}/**/*.rb', '{lib}/**/*.json', '*.md', 'LICENSE']
  s.require_path = 'lib'
  s.homepage = 'https://github.com/schmich/hearthstone-deckstrings'
  s.license = 'MIT'
  s.required_ruby_version = '>= 2.0.0'
end
