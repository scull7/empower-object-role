
assert        = require 'assert'
ObjectRoleMap = require '../../src/map.coffee'

describe 'Object Role Map', ->

  it 'should initialize with an empty map', ->

    assert.deepEqual ObjectRoleMap().map, {}

  describe 'addHandler', ->

    it 'should add throw TypeError if the handler is not a function', ->

      try
        map = ObjectRoleMap()
        map.addHandler 'test', 'test'
      catch e
        assert.equal e.message, 'handler must be a function'

    it 'should throw an error on a duplicate object name', ->

      try
        map = ObjectRoleMap()
        map.addHandler 'test', -> []
        map.addHandler 'test', -> []
      catch e
        assert.equal e.message, 'Handler for test already exists'

    it 'should add the handler at the object name key', ->

      handler = -> []
      map     = ObjectRoleMap()
      map.addHandler 'test', handler

      assert.equal map.map.test, handler

    it 'should return the role map so that we can chain addHandler calls', ->

      map     = ObjectRoleMap()
      map.addHandler 'test', -> []
        .addHandler 'test2', -> []

      assert.equal (map.hasHandler 'test' ), true
      assert.equal (map.hasHandler 'test2' ), true

  describe 'hasHandler', ->

    it 'should return false when the objectName key does not exist', ->

      map = ObjectRoleMap()
      assert.equal (map.hasHandler 'dne'), false

    it 'should return true when the objectName key exists', ->

      map = ObjectRoleMap()
      map.addHandler 'test', -> []
      assert.equal (map.hasHandler 'test'), true

  describe 'getHandler', ->

    it 'should return the nil handler when the objectName key does not exist',
    (done) ->
      map     = ObjectRoleMap()
      handler = map.getHandler 'test'

      handler 'test', 'test', (err, res) ->
        assert.equal err, null
        assert.deepEqual res, []
        done()

    it 'should return the set handler when the objectName key does exist',
    (done) ->

      map     = ObjectRoleMap()
      map.addHandler 'test', (ctx, id, cb)-> cb null, 'testResponse'
      handler = map.getHandler 'test'

      handler 'test', 'test', (err, res) ->
        assert.equal err, null
        assert.equal res, 'testResponse'
        done()

  describe 'getRoles', ->

    it 'should return an empty list if the objectName key does not exist',
    (done) ->

      map     = ObjectRoleMap()
      map.getRoles 'test', 'testContext', 'testId', (err, roles) ->
        assert.equal err, null
        assert.deepEqual roles, []
        done()

    it 'should return the list provided by a found handler', (done) ->

      handler = (ctx, id, done) -> done null, [ctx, id]

      map     = ObjectRoleMap()
      map.addHandler 'test', handler

      map.getRoles 'test', 'testContext', 'testId', (err, roles) ->

        assert.equal err, null
        assert.equal 'testContext', roles[0]
        assert.equal 'testId', roles[1]
        done()
