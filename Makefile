gem: lib/deckstrings/database.json
	gem build deckstrings.gemspec

lib/deckstrings/database.json:
	ruby make-database.rb > lib/deckstrings/database.json	
