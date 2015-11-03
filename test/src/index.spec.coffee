
assert  = require 'assert'
Map     = require '../../src/index.coffee'

handlerFactory = (res) -> (ctx, id, done) -> done null, res

testMap = Map()
testMap.addHandler 'test1', handlerFactory [ 'one', 'two', 'three' ]
testMap.addHandler 'test2', handlerFactory [ 'four', 'five' ]
testMap.addHandler 'test3', handlerFactory [ 'six', 'seven', 'eight']

describe 'Object Role Handler Map', ->

  it 'should give the callback a list of roles', (done) ->

    testMap.getRoles 'test2', {}, 45, (err, roles) ->
      assert.equal err, null
      assert.deepEqual roles, [ 'four', 'five' ]
      done()
