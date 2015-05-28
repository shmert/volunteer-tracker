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

    @allUsers = (params) ->
      $http.get(REST_URL + '/users', {params:params})

    @allUserNames = ->
      $http.get(REST_URL + '/user-names')

    @findById = (id) ->
      $http.get(REST_URL + '/users/' + id)

    @quickSearch = (q) ->
      $http.get(REST_URL + '/users', {params:{q:q}})

    @fetchById = (ids) ->
      $http.get(REST_URL + '/users-by-id', {params:{ids:ids.join(',')}})

    @save = (u) ->
      payload = {
        id:u.id
        targetHours:u.targetHours
        adminOfCategories:_.chain(u.adminOfCategories).map((v,k)->return k if v).filter().value()
        linkedUserIds:_.keys(u.linkedUsers)
      }
      $http.post(REST_URL + '/users-volunteer-settings', payload)

    return this;
