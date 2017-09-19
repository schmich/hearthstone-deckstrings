# Releasing

- `git tag -s x.y.z -m 'Release x.y.z.'`
- `git push && git push --tags`
- `make gem-test`
- `gem push deckstrings-x.y.z.gem`
