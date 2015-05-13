'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:VolunteerappctrlCtrl
 # @description
 # # VolunteerappctrlCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'VolunteerAppCtrl', ($scope, session) ->
    $scope.loggedIn = false;
    $scope.$on('loggedIn', (loggedIn) ->
      $scope.loggedIn = loggedIn
      console.log('Showing main app content') if (loggedIn)
    )
    $scope.isAdmin =-> session.schoologyAccount.admin