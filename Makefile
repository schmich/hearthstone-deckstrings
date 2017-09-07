gem: lib/deckstrings/database.json
	gem build deckstrings.gemspec

test:
	ruby -Ilib test/test.rb

lib/deckstrings/database.json:
	ruby make-database.rb > lib/deckstrings/database.json	

.PHONY: test gem
