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
    unwrap = (response) -> response.data;

    @findById = (id) ->
      $http.get(REST_URL + '/group-objects/' + id).then(unwrap)

    @findMyGroups = ->
      $http.get(REST_URL + '/groups-mine').then(unwrap)

    return this;

