'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminUsersCtrl
 # @description
 # # AdminUsersCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'AdminUsersCtrl', ($scope, $modal, volunteerUtils, users, allJobs) ->
    $scope.q = ''
    $scope.users = users;
    $scope.selected = {}
    $scope.selectionKeys = []
    $scope.selectionDidChange = -> $scope.selectionKeys = _.chain($scope.selected).pick((v) -> v).keys().value()

    $scope.exportUserSignUps = ->
      alert('This will download a csv containing all sign ups for your users. Not yet implemented.') # FIX!!!

    $scope.clearSelection = ->
      $scope.selected = {}
      $scope.selectionDidChange()

    $scope.customFilter = (user) -> # always returns true for selected users, otherwise filters by name
      return true if ($scope.selected[user.id])
      return user.fullName.toLowerCase().indexOf($scope.q) != -1

    #$scope.families = {}
    #addOrAppendToFamily = (user) ->
    #  didLink = $scope.families[link].people.push(user) for link,ignored of user.linkedUsers when $scope.families[link]
    #  $scope.families[user.id] = {people:[user]} if (!didLink)
    #addOrAppendToFamily(user) for user in users

    $scope.linkedUsers = (user) ->
      return (findUser(userId) for userId in _.keys(user.linkedUsers))

    $scope.hoursFor = (person) ->
      result = 0
      result += volunteerUtils.durationOf(timeSlot) for signUp in timeSlot.signUps when signUp.userId==person.id for timeSlot in job.timeSlots for job in allJobs
      return result

    $scope.unlink = (user, linkedUser) ->
      return if !confirm('Are you sure you want to remove the link between these two users?')
      delete user.linkedUsers[linkedUser.id]
      delete linkedUser.linkedUsers[user.id]
      $scope.$emit('save')

    $scope.linkSelectedUsers = ->
      return if !confirm('Are you sure you want to link the ' + $scope.selectionKeys.length + ' selected users?')
      linkUser(u) for u in $scope.selectionKeys
      $scope.clearSelection()
      $scope.$emit('save')

    linkUser = (userId) ->
      user = findUser(userId)
      user.linkedUsers[linkMe] = true for linkMe in $scope.selectionKeys when linkMe != userId

    findUser = (userId) ->
      _.find(users, (u)->u.id.toString()==userId.toString())

    $scope.editCategories = (user) ->
      $modal.open ({
        templateUrl:'userAdminEditCategories.html'
      }).result.then ->
        alert('Saving user changes') # FIX!!!
