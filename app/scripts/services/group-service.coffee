'use strict'

###*
 # @ngdoc service
 # @name volunteerTrackerHtmlApp.groupService
 # @description
 # # groupService
 # Service in the volunteerTrackerHtmlApp.
###
angular.module 'volunteerTrackerHtmlApp'
  .service 'groupService', ($rootScope, $http, REST_URL) ->
    @findById = (id) ->
      $http.get(REST_URL + '/group-objects/' + id)

    @findMyGroups = ->
      $http.get(REST_URL + '/groups-mine')

    return this;

