Map               = require './map'
jsonToMap         = require './json-to-map'
{
  getRolesFromUrl
}                 = require './url-map-role'

privilegeObjectRole = (map) -> (context, url, done) ->
  getRolesFromUrl(map, context, url, done)

privilegeObjectRole.Map       = Map
privilegeObjectRole.fromJson  = (json) -> privilegeObjectRole (jsonToMap json)


module.exports    = privilegeObjectRole
