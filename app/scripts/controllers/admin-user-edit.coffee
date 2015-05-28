'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminUserEditCtrl
 # @description
 # # AdminUserEditCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'AdminUserEditCtrl', ($scope, $window, $http, $location, REST_URL, userService, user, session) ->
    $scope.user = user.data;
    $scope.user.targetHours = 20 if $scope.user.targetHours == undefined
    $scope.user.adminOfCategories = _.chain($scope.user.adminOfCategories).indexBy().mapValues(->true).value();
    $scope.user.x = $scope.user.linkedUsers
    $scope.user.linkedUsers = [{user:'asdf'}]

    $scope.queryCategories = (q) -> $http.get(
        REST_URL + '/groups',
        {params:{q:q},withCredentials:true}).then (response)-> _.map(response.data, 'title')

    $scope.findUsers = (q) ->
      userService.quickSearch(q).then (found) ->
        return found.data

    $scope.ensureEmptyVolunteerSlotExists = ->
      if ($scope.user.linkedUsers.length == 0 || $scope.user.linkedUsers[$scope.user.linkedUsers.length - 1].user != null)
        $scope.user.linkedUsers.push({user: null})

    $scope.removeVolunteer = ($index) ->
      $scope.user.linkedUsers.splice($index, 1)
      $scope.ensureEmptyVolunteerSlotExists()

    $scope.loginAsThisUser = ->
      session.switchUser(u.id).then( -> $location.path('/'));

    $scope.save = ->
      userService.save($scope.user).then(
        -> $window.history.back()
      ).catch( (err) -> alert("Error while saving! " + err) )

    $scope.ensureEmptyVolunteerSlotExists()