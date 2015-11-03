
class Map

  EMPTY_LIST  = []
  # type Handler :: Context -> String -> (Error -> Array String)
  # type Callback :: Error -> Array String -> Nil
  NIL_HANDLER = (context, objectId, done) -> done null, EMPTY_LIST

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


  # getHandler :: String -> Handler
  getHandler: (objectName) -> if (@hasHandler objectName)
    @map[objectName]
  else NIL_HANDLER


  # getRoles :: String -> Context -> String -> Callback -> Nil
  getRoles: (objectName, context, id, done) ->
    (@getHandler objectName) context, id, done


module.exports  = -> new Map()
