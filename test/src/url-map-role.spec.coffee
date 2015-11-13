
assert      = require 'assert'
urlMapRole  = require '../../src/url-map-role'

describe 'Url -> Map -> Role', ->

  describe 'getObjectsWithHandlers', ->

    it 'should only return url objects with matching handlers', ->

      map = hasHandler: (objName) -> if objName is 'sub' then yes else no
      test  = '/my/object/123/sub/425/action'
      expected  = [
        { name: 'sub', id: '425' }
      ]
      actual    = urlMapRole.getObjectsWithHandlers map, test

      assert.deepEqual expected, actual

  describe 'getRolesForObject', ->

    it 'should call the get roles function on the given map object', (done) ->

      map = getRoles: (name, ctx, id, cb) -> cb null, [name, ctx, id]
      expected  = ['test_name', 'test_ctx', 'test_id' ]
      testObj   =
        name: 'test_name'
        id: 'test_id'

      urlMapRole.getRolesForObject map, 'test_ctx', testObj, (err, actual) ->
        assert.deepEqual expected, actual
        done()


  describe 'getRolesForObjectList', ->

    it 'should return a combined list of roles', (done) ->

      expected  = [ 'role_obj1', 'role_obj3', 'role_obj4', 'role_obj4.2' ]
      testList  = [
        { name: 'object1', id: '123' }
        { name: 'object2', id: '456' }
        { name: 'object3', id: '789' }
        { name: 'object4', id: '987' }
        { name: 'object5', id: '654' }
      ]
      context   = {
        'object1': [ 'role_obj1' ]
        'object3': [ 'role_obj3' ]
        'object4': [ 'role_obj4', 'role_obj4.2' ]
        'object5': []
      }

      map = getRoles: (name, context, id, done) ->
        if context[name] then (done null, context[name]) else (done null, [])

      urlMapRole.getRolesForObjectList map, context, testList, (err, actual) ->
        assert.deepEqual expected, actual
        done()

    it 'should forward any encountered errors', (done) ->

      expected  = [ 'object2_not_found', 'object5_not_found' ]
      testList  = [
        { name: 'object1', id: '123' }
        { name: 'object2', id: '456' }
        { name: 'object3', id: '789' }
        { name: 'object4', id: '987' }
        { name: 'object5', id: '654' }
      ]
      context   = {
        'object1': [ 'role_obj1' ]
        'object3': [ 'role_obj3' ]
        'object4': [ 'role_obj4', 'role_obj4.2' ]
      }

      map = getRoles: (name, context, id, done) -> if not context[name]
        done("#{name}_not_found")
      else
        done(null, context[name])

      urlMapRole.getRolesForObjectList map, context, testList, (err, actual) ->
        assert.deepEqual undefined, actual
        assert.deepEqual expected, err
        done()


  describe 'getRolesFromUrl', ->

    it 'should return a combined list of roles', (done) ->

      test  = '/my/object/123/sub/425/action'
      expected  = [ 'objectOwner' ]
      context   =
        'object': '123'
        'sub': '456'

      map = getRoles: (name, context, id, done) -> if context[name] is id
        done null, [ "#{name}Owner" ]
      else
        done null, []

      urlMapRole.getRolesFromUrl map, context, test, (err, actual) ->
        assert.deepEqual expected, actual
        done()

    it 'should return a combined list of roles', (done) ->

      test  = '/my/object/123/sub/425/action'
      expected  = [ 'objectOwner', 'subOwner' ]
      context   =
        'object': '123'
        'sub': '425'

      map = getRoles: (name, context, id, done) -> if context[name] is id
        done null, [ "#{name}Owner" ]
      else
        done null, []

      urlMapRole.getRolesFromUrl map, context, test, (err, actual) ->
        assert.deepEqual expected, actual
        done()
