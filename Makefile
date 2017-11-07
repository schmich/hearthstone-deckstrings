gem: lib/deckstrings/database.json
	gem build deckstrings.gemspec

doc:
	rm -rf doc && yard server --reload

irb:
	irb -Ilib -rdeckstrings

test:
	ruby -Ilib test/test.rb

gem-test: gem
	rm -rf /tmp/deckstrings && mkdir /tmp/deckstrings
	cp *.gem /tmp/deckstrings
	(cd /tmp/deckstrings && tar xf *.gem && tar zxf data.tar.gz)
	ruby -I/tmp/deckstrings/lib test/test.rb

database:
	rm lib/deckstrings/database.json
	ruby make-database.rb > lib/deckstrings/database.json	

lib/deckstrings/database.json:
	ruby make-database.rb > lib/deckstrings/database.json	

.PHONY: test gem doc irb gem-test database
