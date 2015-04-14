'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'MainCtrl', ($scope, $filter, volunteerUtils, allJobs, users) ->
    $scope.showingCompletedJobs = false

    recalculate = ->
      handleJob = (job) ->
        handleTimeSlot(job, slot) for slot in job.timeSlots

      handleTimeSlot = (job, timeSlot) ->
        handleSignUp(job, timeSlot, signUp) for signUp in timeSlot.signUps when (signUp.userId == $scope.user.id || $scope.user?.linkedUsers[signUp.userId])

      handleSignUp = (job, timeSlot, signUp) ->
        duration = volunteerUtils.durationOf(timeSlot)
        if (signUp.verified)
          $scope.completeVerified += duration
        else
          $scope.completeUnverified += duration
        $scope.mySignUps.push {
          job:job
          timeSlot:timeSlot
          signUp:signUp
          duration:duration
        }

      $scope.mySignUps = []
      $scope.target = 20
      $scope.completeUnverified = 0
      $scope.completeVerified = 0

      handleJob job for job in allJobs
      $scope.mySignUps = $filter('orderBy')($scope.mySignUps, ['signUp.date'])
      $scope.percentCompleteVerified = Math.min(100, $scope.completeVerified / $scope.target * 100);
      $scope.percentCompleteUnverified = Math.min(100, $scope.completeUnverified / $scope.target * 100);


    recalculate()

    $scope.progressBarTitle =->
      result = []
      result.push '' + $scope.completeVerified + ' completed' if $scope.completeVerified
      result.push '' + $scope.completeUnverified + ' pending' if $scope.completeUnverified
      return result.join(', ')

    $scope.isInPast = (dateString) -> moment(dateString).isBefore(new Date())

    $scope.showingCompletedFilter = (o) -> $scope.showingCompletedJobs || !$scope.isInPast(o.signUp.date)

    $scope.toggleOldJobs =-> $scope.showingCompletedJobs = !$scope.showingCompletedJobs

    $scope.userOptions = users

    $scope.switchUser = (u) ->
      $scope.$emit('su', u)
      recalculate()
    $scope.resetData = ->
      return if !confirm('Are you sure you want to reset? All your changes will be lost')
      $scope.$emit('resetData')
      recalculate()