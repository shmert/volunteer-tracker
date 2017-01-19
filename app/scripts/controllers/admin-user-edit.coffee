'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminUserEditCtrl
 # @description
 # # AdminUserEditCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'AdminUserEditCtrl', ($scope, $window, $http, $location, REST_URL, jobService, userService, user, session) ->
    $scope.user = user.data;
    $scope.user.targetHours = 20 if $scope.user.targetHours == undefined
    $scope.user.adminOfCategories = _.chain($scope.user.adminOfCategories).indexBy().mapValues(->true).value();
    $scope.newUser = null; # set by typeahead input, then cleared on selection
    $scope.linkedUsers = [] # will be replaced by ajax call
    $scope.jobs = null # will be loaded asynchronously

    jobService.findByUserId($scope.user.id).then (found) -> $scope.jobs = found.data

    $scope.transientLinkedHours = 0;
    $scope.oldTargetHours = $scope.user.targetHours;

    $scope.targetHoursFamily = () ->
      return ($scope.user.targetHours || 20) - $scope.oldTargetHours + $scope.transientLinkedHours + ($scope.user.targetHoursLinked || 0);


    userService.fetchById(_.keys($scope.user.linkedUsers)).success (array) ->
      $scope.linkedUsers = array

    $scope.queryCategories = (q) -> $http.get(
        REST_URL + '/groups',
        {params:{q:q},withCredentials:true}).then (response)-> _.map(response.data, 'title')

    $scope.removeLinkedUser = (index) ->
      return if !confirm('Are you sure you want to remove this linked user?')
      $scope.transientLinkedHours -= ($scope.linkedUsers[index].targetHours || 20);
      $scope.linkedUsers.splice(index, 1)

    $scope.findUsers = (q) ->
      userService.quickSearch(q).then (found) ->
        return _.filter(found.data, (u)->
                u.id.toString() != $scope.user.id.toString())

    $scope.didChooseLinkedUser = ->
      return alert('This user is already linked') if _.find($scope.linkedUsers, (u)->u.id.toString()==$scope.newUser.id.toString())
      $scope.linkedUsers.push $scope.newUser
      $scope.transientLinkedHours += $scope.newUser.targetHours;
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

    $scope.showUsersJob = ->
      $location.path('/job-list').search('user', $scope.user.id).search('showAll', 'true')

