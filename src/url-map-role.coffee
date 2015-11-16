
###
  Take a url and map it to a collection of object specific roles.
  ===============================================================
###

urlUtil     = require './util'

flatten     = (arr) -> Array.prototype.concat.apply([], arr)


# getObjectsWithHandlers :: HandlerMap -> String -> Array UrlObject
getObjectsWithHandlers  = (map, url) ->
  (urlUtil.getObjectsFromUrl url).filter (obj) -> map.hasHandler obj.name


# getRolesForObject :: HandlerMap -> Context -> UrlObject -> Callback -> Nil
getRolesForObject = (map, context, object, done) ->
  map.getRoles object.name, context, object.id, done


# getRolesForObjectList ::
#   HandlerMap -> Context -> Array UrlObject -> Callback -> Nil
getRolesForObjectList  = (map, context, listOfObjects, done) ->
  count           = listOfObjects.length
  errors          = []
  listOfRoleLists = []

  if count < 1 then return done null, listOfRoleLists

  handler = (err, listOfRoles) ->
    errors.push err if err
    listOfRoleLists.push listOfRoles if listOfRoles
    count -= 1

    if count < 1
      return if errors.length > 0
        done(errors)
      else done(null, (flatten listOfRoleLists))

  getRolesForObject map, context, obj, handler for obj in listOfObjects

# getRolesFromUrl :: HandlerMap -> Context -> String -> Callback -> Nil
getRolesFromUrl = (map, context, url, done) ->
  getRolesForObjectList map, context, (urlUtil.getObjectsFromUrl url), done


module.exports  =
  getObjectsWithHandlers    : getObjectsWithHandlers
  getRolesForObject         : getRolesForObject
  getRolesForObjectList     : getRolesForObjectList
  getRolesFromUrl           : getRolesFromUrl
