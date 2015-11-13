
assert  = require 'assert'
utils   = require '../../src/util'

describe 'Url Object Utilities', ->

  describe 'isValidName', ->

    it 'should return false when an integer string is given', ->
      assert.equal false, utils.isValidName '123'

    it 'should return false when null is given', ->
      assert.equal false, utils.isValidName null

    it 'should return false when undefined is given', ->
      assert.equal false, utils.isValidName undefined

    it 'should return false when an empty string is given', ->
      assert.equal false, utils.isValidName ''

    it 'should return true when a non-zero length, non-integer string is given',
    ->
      assert.equal true, utils.isValidName 'notint'


  describe 'isValidValue', ->

    it 'should return false if null is given', ->
      assert.equal false, utils.isValidValue null

    it 'should return false if undefined is given', ->
      assert.equal false, utils.isValidValue undefined

    it 'should return false if an empty string is given', ->
      assert.equal false, utils.isValidValue ''

    it 'should return true for a non-zero length string', ->
      assert.equal true, utils.isValidValue 'fefifofum'


  describe 'UrlObject', ->

    it 'should return a url object ', ->

      expected =
        name: 'test'
        id: '123'

      assert.deepEqual expected, (utils.UrlObject 'test', '123')

  describe 'tokenizeUrl', ->

    it 'should split a url by "/"', ->
      test      = "/my/fancy/test/213/action/"
      expected  = [ '', 'my', 'fancy', 'test', '213', 'action', '' ]
      actual    = utils.tokenizeUrl test

      assert.deepEqual expected, actual

    it 'should return [ "" ] for an empty string', ->

      test      = ''
      expected  = [ '' ]
      actual    = utils.tokenizeUrl test

      assert.deepEqual expected, actual

    it 'should return [ "", "" ] for a root url', ->

      test      = '/'
      expected  = [ '', '' ]
      actual    = utils.tokenizeUrl test

      assert.deepEqual expected, actual

  describe 'urlTokensToObjects', ->

    it 'should return an empty array for the empty string', ->

      test      = ''
      expected  = []
      actual    = utils.getObjectsFromUrl test

      assert.deepEqual expected, actual

    it 'should return an empty array for the root url', ->

      test      = '/'
      expected  = []
      actual    = utils.getObjectsFromUrl test

      assert.deepEqual expected, actual

    it 'should return all possible object combinations', ->

      test      = '/my/fancy/test/213/action/'
      expected  = [
        { name: 'my', id: 'fancy' }
        { name: 'fancy', id: 'test' }
        { name: 'test', id: '213' }
      ]
      actual    = utils.getObjectsFromUrl test

      assert.deepEqual expected, actual

    it 'should handle sub objects properly', ->

      test  = '/my/object/123/sub/425/action'
      expected  = [
        { name: 'my', id: 'object' }
        { name: 'object', id: '123' }
        { name: 'sub', id: '425' }
      ]
      actual    = utils.getObjectsFromUrl test

      assert.deepEqual expected, actual
