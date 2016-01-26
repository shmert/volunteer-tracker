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
    $scope.newUser = null; # set by typeahead input, then cleared on selection
    $scope.linkedUsers = [] # will be replaced by ajax call

    userService.fetchById(_.keys($scope.user.linkedUsers)).success (array) ->
      $scope.linkedUsers = array

    $scope.queryCategories = (q) -> $http.get(
        REST_URL + '/groups',
        {params:{q:q},withCredentials:true}).then (response)-> _.map(response.data, 'title')

    $scope.removeLinkedUser = (index) ->
      return if !confirm('Are you sure you want to remove this linked user?')
      $scope.linkedUsers.splice(index, 1)

    $scope.findUsers = (q) ->
      userService.quickSearch(q).then (found) ->
        return _.filter(found.data, (u)->
                u.id.toString() != $scope.user.id.toString())

    $scope.didChooseLinkedUser = ->
      return alert('This user is already linked') if _.find($scope.linkedUsers, (u)->u.id.toString()==$scope.newUser.id.toString())
      $scope.linkedUsers.push $scope.newUser
      $scope.newUser = null;

    $scope.loginAsThisUser = ->
      session.switchUser($scope.user.id).then( -> $location.path('/'));

    $scope.save = ->
      $scope.user.linkedUsers = _.chain($scope.linkedUsers).map('id').indexBy().value()
      userService.save($scope.user).then(
        -> $window.history.back()
      ).catch( (err) ->
        session.logAndReportError(err, "An error occurred while saving this user")
      )
#        alert("Error while saving! " + err.data) )

