

# isValidName :: String -> Bool
isValidName  = (str) -> switch
  when not isNaN (parseInt str, 10) then no
  when str is null then no
  when str is undefined then no
  when str.length < 1 then no
  else yes


# isValidValue :: String -> Bool
isValidValue  = (val) -> switch
  when val is null then no
  when val is undefined then no
  when (typeof val) is 'string' and val.length < 1 then no
  else yes


# type alias UrlObject = { name: String, id: String }
UrlObject  = (name, id) ->
  name: name
  id: id


# tokenizeUrl :: String -> Array UrlObject
tokenizeUrl = (url) -> url.split '/'


# _objectFoldp ::
#   Array UrlObject -> String -> Int -> Array String -> Array UrlObject
_objectFoldp  = (acc, cur, index, arr) ->
  if (isValidName cur) and (isValidValue arr[index + 1])
    acc.concat (UrlObject cur, arr[index + 1])
  else
    acc


# getObjectsFromUrl :: String -> Array UrlObject
getObjectsFromUrl  = (url) -> (tokenizeUrl url).reduce _objectFoldp, []


module.exports  =
  UrlObject               : UrlObject
  isValidName             : isValidName
  isValidValue            : isValidValue
  tokenizeUrl             : tokenizeUrl
  getObjectsFromUrl       : getObjectsFromUrl
