'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:ProfileEditCtrl
 # @description
 # # ProfileEditCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'ProfileEditCtrl', ($scope, $location, session, userService) ->
    $scope.newUser = null; # set by typeahead input, then cleared on selection
    $scope.linkedUsers = [] # will be replaced by ajax call

    userService.findById(session.userAccount.id).then (found) ->
      $scope.user = found;
      $scope.user.phone = $scope.user.profile_info.phone if !$scope.user.phone # use schoology phone if none specified
    .then ()->
      userService.fetchById(_.keys($scope.user.linkedUsers)).then (array) ->
        $scope.linkedUsers = array

    $scope.save = () ->
      $scope.user.linkedUsers = _.chain($scope.linkedUsers).map('id').indexBy().value()
      userService.updateUser($scope.user).then(
        (updated) ->
          alert('Your account has been updated, thanks!')
#          session.userAccount = updated;
          $location.path('/admin')
        , (e) ->
          session.logAndReportError(e)
      )

    $scope.findUsers = (q) ->
      userService.quickSearch(q).then (found) ->
        return _.filter(found, (u)->
              u.id.toString() != $scope.user.id.toString())

    $scope.removeLinkedUser = (index) ->
      return if !confirm('Are you sure you want to remove this linked user?')
      $scope.linkedUsers.splice(index, 1)

    $scope.didChooseLinkedUser = ->
      return alert('This user is already linked') if _.find($scope.linkedUsers, (u)->u.id.toString()==$scope.newUser.id.toString())
      $scope.linkedUsers.push $scope.newUser
      $scope.newUser = null;

    return
