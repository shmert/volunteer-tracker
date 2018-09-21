'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:GroupsCtrl
 # @description
 # # GroupsCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'GroupsCtrl', ($scope, groups) ->
    $scope.groups = groups;
    $scope.foo = $scope.groups;

    return
