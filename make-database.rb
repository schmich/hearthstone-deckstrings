require 'open-uri'
require 'json'
require 'pp'

open('https://api.hearthstonejson.com/v1/latest/enUS/cards.json') do |r|
  all_info = JSON.parse(r.read, symbolize_names: true)

  heroes = all_info
    .select { |c| c[:type] == 'HERO' && c[:collectible] && !c[:cost] && c[:dbfId] }
    .map { |c| { name: c[:name], class: c[:cardClass].downcase, dbf_id: c[:dbfId] } }
    .map { |c| [c[:dbf_id], c.delete(:dbf_id) && c] }
    .sort_by { |id, _| id }
    .to_h

  cards = all_info
    .select { |c| c[:cost] && c[:dbfId] }
    .map { |c| { name: c[:name], cost: c[:cost], dbf_id: c[:dbfId] } }
    .map { |c| [c[:dbf_id], c.delete(:dbf_id) && c] }
    .sort_by { |id, _| id }
    .to_h

  database = {
    heroes: heroes,
    cards: cards
  }

  puts JSON.dump(database)
end
