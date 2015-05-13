'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminCtrl
 # @description
 # # AdminCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'AdminCtrl', ($scope, $location) ->

    $scope.add = ->
      $location.path('/job-add')


