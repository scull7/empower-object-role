
assert              = require 'assert'
PrivilegeObjectRole = require '../../src/index.coffee'

handlerFactory = (res) -> (ctx, id, done) -> done null, res


describe 'Object Role Handler Map', ->
  getRoles      = null
  getRolesJson  = null

  before ->
    testMap = PrivilegeObjectRole.Map()
    testMap.addHandler 'test1', handlerFactory [ 'one', 'two', 'three' ]
    testMap.addHandler 'test2', handlerFactory [ 'four', 'five' ]
    testMap.addHandler 'test3', handlerFactory [ 'six', 'seven', 'eight']

    getRoles  = PrivilegeObjectRole testMap

    getRolesJson  = PrivilegeObjectRole.fromJson
      'test1': handlerFactory [ 'one', 'two', 'three' ]
      'test2': handlerFactory [ 'four', 'five' ]
      'test3': handlerFactory [ 'six', 'seven', 'eight']


  it 'should give the callback a list of roles', (done) ->

    testUrl   = '/test/test1/123/test3/456/action'
    testCtx   = {}
    expected  = [ 'one', 'two', 'three', 'six', 'seven', 'eight' ]

    getRoles testCtx, testUrl, (err, actual) ->
      assert.deepEqual expected, actual
      done()


  it 'should perform the same when initialized with JSON', (done) ->

    testUrl   = '/test/test1/123/test3/456/action'
    testCtx   = {}
    expected  = [ 'one', 'two', 'three', 'six', 'seven', 'eight' ]

    getRolesJson testCtx, testUrl, (err, actual) ->
      assert.deepEqual expected, actual
      done()
