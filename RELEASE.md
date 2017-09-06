# Releasing

- Update version in `lib/deckstrings/version.rb`
- git tag -s x.y.z -m 'Release x.y.z.'
- git push && git push --tags
- make gem
- gem push deckstrings-x.y.z.gem
