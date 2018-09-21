'use strict'

###*
 # @ngdoc service
 # @name volunteerTrackerHtmlApp.userService
 # @description
 # # userService
 # Service in the volunteerTrackerHtmlApp.
###
angular.module 'volunteerTrackerHtmlApp'
  .service 'userService', ($http, REST_URL) ->
    #users = [
    #  {id: 1, fullName: 'Admin Person', admin:true, linkedUsers:{}, targetHours:0}
    #  {id: 123, fullName: 'Wendy Three', linkedUsers:{53:true}, targetHours:40}
    #  {id: 53, fullName: 'Fitz Three', linkedUsers:{123:true}, targetHours:40}
    #  {id: 42, fullName: 'Ford E. Tou', linkedUsers:{}, targetHours:20}
    #  {id: 456, fullName: 'Lonesome Lou', linkedUsers:{}, targetHours:20}
    #]
    unwrap = (response) -> response.data;

    @allUsers = (params) ->
      $http.get(REST_URL + '/users', {params:params}).then(unwrap);

    @allUserNames = ->
      $http.get(REST_URL + '/user-names').then(unwrap);

    @findById = (id) ->
      $http.get(REST_URL + '/users/' + id).then(unwrap);

    @findByGroupId = (id) ->
      $http.get(REST_URL + '/groups/' + id + '/users').then(unwrap);

    @quickSearch = (q, config) ->
      config = {} if !config
      $http.get(REST_URL + '/users', {params:{q:q, 'groups[]':config.groups, linkedTo:config.linkedTo, admin:config.admin}}).then(unwrap);

    @fetchById = (ids) ->
      $http.get(REST_URL + '/users-by-id', {params:{ids:ids.join(',')}}).then(unwrap);

    @updateUser = (user) ->
      user.linkedUserIds = _.keys(user.linkedUsers)
      $http.put(REST_URL + '/users/' + user.id, user).then(unwrap);

    @save = (u) ->
      payload = {
        id:u.id
        targetHours:u.targetHours
        adminOfCategories:_.chain(u.adminOfCategories).map((v,k)->return k if v).filter().value()
        linkedUserIds:_.keys(u.linkedUsers)
      }
      $http.post(REST_URL + '/users-volunteer-settings', payload).then(unwrap);

    return this;
