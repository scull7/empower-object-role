// Generated by CoffeeScript 1.10.0

/*
  Take a url and map it to a collection of object specific roles.
  ===============================================================
 */

(function() {
  var flatten, getObjectsWithHandlers, getRolesForObject, getRolesForObjectList, getRolesFromUrl, urlUtil;

  urlUtil = require('./util');

  flatten = function(arr) {
    return Array.prototype.concat.apply([], arr);
  };

  getObjectsWithHandlers = function(map, url) {
    return (urlUtil.getObjectsFromUrl(url)).filter(function(obj) {
      return map.hasHandler(obj.name);
    });
  };

  getRolesForObject = function(map, context, object, done) {
    return map.getRoles(object.name, context, object.id, done);
  };

  getRolesForObjectList = function(map, context, listOfObjects, done) {
    var count, errors, handler, i, len, listOfRoleLists, obj, results;
    count = listOfObjects.length;
    errors = [];
    listOfRoleLists = [];
    if (count < 1) {
      return done(null, listOfRoleLists);
    }
    handler = function(err, listOfRoles) {
      if (err) {
        errors.push(err);
      }
      if (listOfRoles) {
        listOfRoleLists.push(listOfRoles);
      }
      count -= 1;
      if (count < 1) {
        if (errors.length > 0) {
          return done(errors);
        } else {
          return done(null, flatten(listOfRoleLists));
        }
      }
    };
    results = [];
    for (i = 0, len = listOfObjects.length; i < len; i++) {
      obj = listOfObjects[i];
      results.push(getRolesForObject(map, context, obj, handler));
    }
    return results;
  };

  getRolesFromUrl = function(map, context, url, done) {
    return getRolesForObjectList(map, context, urlUtil.getObjectsFromUrl(url), done);
  };

  module.exports = {
    getObjectsWithHandlers: getObjectsWithHandlers,
    getRolesForObject: getRolesForObject,
    getRolesForObjectList: getRolesForObjectList,
    getRolesFromUrl: getRolesFromUrl
  };

}).call(this);
