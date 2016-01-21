'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminUsersCtrl
 # @description
 # # AdminUsersCtrl
 # Controller of the volunteerTrackerHtmlApp
  Sample user: {id: 53, fullName: 'Fitz Three', linkedUsers:{123:true}, targetHours:40}
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'AdminUsersCtrl', ($scope, $uibModal, $location, volunteerUtils, allJobs, userService, session) ->
    $scope.q = ''
    $scope.users = [];
    $scope.selected = {}
    $scope.selectionKeys = []
    $scope.selectionDidChange = -> $scope.selectionKeys = _.chain($scope.selected).pick((v) -> v).keys().value()

    $scope.search = ->
      userService.quickSearch($scope.q).success (response) ->
        #response.unshift($scope.users[userId]) for userId in $scope.selectionKeys # fix! only add if userId is not in response
        $scope.users = response;
        #$scope.users.unshift(selected) for selected in _.values($scope.selected) when not _.contains($scope.users, selected)
        #$scope.users.unshift.apply($scope.users, _.values($scope.selected) )

    #$scope.clearSelection = ->
    #  $scope.selected = {}
    #  $scope.selectionDidChange()

    #$scope.customFilter = (user) -> # always returns true for selected users, otherwise filters by name
    #  return true if ($scope.selected[user.id])
    #  if (user.$fullNameLower == undefined)
    #    user.$fullNameLower = user.fullName.toLowerCase()
    #  return user.$fullNameLower.indexOf($scope.q) != -1

    #$scope.families = {}
    #addOrAppendToFamily = (user) ->
    #  didLink = $scope.families[link].people.push(user) for link,ignored of user.linkedUsers when $scope.families[link]
    #  $scope.families[user.id] = {people:[user]} if (!didLink)
    #addOrAppendToFamily(user) for user in users

    #$scope.linkedUsers = (user) ->
    #  return (findUser(userId) for userId in _.keys(user.linkedUsers))

    #$scope.hoursFor = (person) ->
    #  result = 0
    #  result += volunteerUtils.durationOf(timeSlot) for signUp in timeSlot.signUps when signUp.userId==person.id for timeSlot in job.timeSlots for job in allJobs
    #  return result

    #$scope.unlink = (user, linkedUser) ->
    #  return if !confirm('Are you sure you want to remove the link between these two users?')
    #  delete user.linkedUsers[linkedUser.id]
    #  delete linkedUser.linkedUsers[user.id]
    #  $scope.$emit('save')

    #$scope.linkSelectedUsers = ->
    #  return if !confirm('Are you sure you want to link the ' + $scope.selectionKeys.length + ' selected users?')
    #  linkUser(u) for u in $scope.selectionKeys
    #  $scope.clearSelection()
    #  $scope.$emit('save')

    #linkUser = (userId) ->
    #  user = findUser(userId)
    #  user.linkedUsers[linkMe] = true for linkMe in $scope.selectionKeys when linkMe != userId

    #findUser = (userId) ->
    #  _.find(users, (u)->u.id.toString()==userId.toString())

    #$scope.editCategories = (user) ->
    #  $modal.open ({
    #    templateUrl:'userAdminEditCategories.html'
    #  }).result.then ->
    #    alert('Saving user changes') # FIX!!!

    #$scope.switchUser = (u) ->
    #  session.switchUser(u.id).then( -> $location.path('/'));

    return this
