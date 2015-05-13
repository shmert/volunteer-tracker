'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:NotLoggedInCtrl
 # @description
 # # NotLoggedInCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'NotLoggedInCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
