
class Map

  EMPTY_LIST  = []

  # constructor :: ObjectRoleMap
  constructor: ->
    @map      = {}


  # addHandler :: String -> (Context -> String -> Array String) -> ObjectRoleMap
  addHandler: (objectName, handler) ->

    if typeof handler isnt 'function'
      throw new TypeError 'handler must be a function'

    if @hasHandler objectName
      throw new Error "Handler for #{objectName} already exists"

    @map[objectName]  = handler
    return @


  # hasHandler :: String -> Bool
  hasHandler: (objectName) -> ( @map.hasOwnProperty objectName )


  # getObjectRoles :: String -> String -> Context -> Array String
  getObjectRoles: (objectName, context, objectId) ->
    if not (@hasHandler objectName) then EMPTY_LIST else
      ( @map[objectName].call null, context, objectId )


module.exports  = -> new Map()
