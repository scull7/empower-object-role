
assert    = require 'assert'
jsonToMap = require '../../src/json-to-map'

describe 'JSON to Handler Map', ->

  it 'should add every handler listed in the json object', ->

    json  =
      'campaign': (ctx, id, done) -> null
      'offer': (ctx, id, done) -> null

    map = jsonToMap json

    assert.equal true, map.hasHandler 'campaign'
    assert.equal true, map.hasHandler 'offer'
