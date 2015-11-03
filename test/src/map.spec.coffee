
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

  describe 'getObjectRoles', ->

    it 'should return an empty list when the objectName key does not exist', ->

      map = ObjectRoleMap()
      assert.deepEqual (map.getObjectRoles 'test', 'test', {}), []

    it 'should call the handler with the objectId and context', (done) ->

      handler = (context, objectId) ->
        assert.equal objectId, 'testId'
        assert.equal context, 'testContext'
        done()

      map     = ObjectRoleMap()
      map.addHandler 'testName', handler

      map.getObjectRoles 'testName', 'testContext', 'testId'
