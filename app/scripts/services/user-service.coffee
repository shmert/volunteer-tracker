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

    @allUsers = -> $http.get(REST_URL + '/users')

    @allUserNames = -> $http.get(REST_URL + '/user-names')

    @quickSearch = (q) ->
      $http.get(REST_URL + '/users', {params:{q:q}})

    return this;
