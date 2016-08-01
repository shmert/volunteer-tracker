'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'MainCtrl', ($scope, $filter, $location, volunteerUtils, myJobs, session) ->
    $scope.showingCompletedJobs = false

    $scope.session = session

    recalculate = ->
      handleJob = (job) ->
        handleTimeSlot(job, task, slot) for slot in task.timeSlots for task in job.tasks

      handleTimeSlot = (job, task, timeSlot) ->
        handleSignUp(job, task, timeSlot, signUp) for signUp in timeSlot.signUps when (signUp.userId.toString() == session.userAccount.id.toString() || session.userAccount.linkedUsers[signUp.userId])

      handleSignUp = (job, task, timeSlot, signUp) ->
        duration = volunteerUtils.durationOf(timeSlot)
        if (signUp.verified)
          $scope.completeVerified += duration
        else
          $scope.completeUnverified += duration
        $scope.mySignUps.push {
          job:job
          task:task
          timeSlot:timeSlot
          signUp:signUp
          duration:duration
        }

      $scope.mySignUps = []
      $scope.target = 20
      $scope.completeUnverified = 0
      $scope.completeVerified = 0

      handleJob job for job in myJobs.data
      $scope.mySignUps = $filter('orderBy')($scope.mySignUps, ['signUp.date'])
      $scope.percentCompleteVerified = Math.round(Math.min(100, $scope.completeVerified / $scope.target * 100));
      $scope.percentCompleteUnverified = Math.round(Math.min(100, $scope.completeUnverified / $scope.target * 100));


    recalculate()

    $scope.progressBarTitle =->
      result = []
      result.push '' + Math.round($scope.completeVerified) + ' hrs completed' if $scope.completeVerified
      result.push '' + Math.round($scope.completeUnverified) + ' hrs pending' if $scope.completeUnverified
      return result.join(', ')

    $scope.isInPast = (dateString) -> moment(dateString).isBefore(new Date())

    $scope.showingCompletedFilter = (o) -> $scope.showingCompletedJobs || !$scope.isInPast(o.signUp.date)

    $scope.toggleOldJobs =-> $scope.showingCompletedJobs = !$scope.showingCompletedJobs

    $scope.isAdminForGroupId = (groupId) ->
      return true if $scope.isAdmin();
      _.indexOf(session.userAccount.adminOfCategories, groupId) != -1;

    $scope.showMyJobs = ->
      $location.path('/job-list').search('user', session.userAccount.id).search('showAll', 'true')

    $scope.resetData = ->
      return if !confirm('Are you sure you want to reset? All your changes will be lost')
      $scope.$emit('resetData')
      recalculate()
