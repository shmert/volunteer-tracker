'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
