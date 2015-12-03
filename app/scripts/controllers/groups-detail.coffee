'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:GroupsDetailCtrl
 # @description
 # # GroupsDetailCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'GroupsDetailCtrl', ($scope, group, userService) ->
    $scope.group = group.data;
    userService.findByGroupId($scope.group.id).then (response) -> $scope.users = response.data
    return
