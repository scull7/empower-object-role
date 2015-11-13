
Map = require './map'

# fromJson :: JSON -> Map
module.exports  = (json) ->

  map = Map()

  map.addHandler name, handler for name, handler of json

  return map
