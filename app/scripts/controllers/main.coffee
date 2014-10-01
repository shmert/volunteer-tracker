'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'MainCtrl', ($scope, $filter, allJobs) ->
    recalculate = ->
      handleJob = (job) ->
        handleTimeSlot(job, slot) for slot in job.timeSlots

      handleTimeSlot = (job, timeSlot) ->
        handleSignUp(job, timeSlot, signUp) for signUp in timeSlot.signUps when signUp.userId == $scope.user.id

      handleSignUp = (job, timeSlot, signUp) ->
        $scope.complete += durationOf(timeSlot)
        $scope.mySignUps.push {
          job:job
          timeSlot:timeSlot
          signUp:signUp
        }

      durationOf = (timeSlot) ->
        end = moment(timeSlot.endTime, 'H:mm')
        start = moment(timeSlot.startTime, 'H:mm')
        return 1 if !end.isValid() || !start.isValid
        return end.diff(start, 'minutes') / 60

      $scope.mySignUps = []
      $scope.target = 20
      $scope.complete = 0
      handleJob job for job in allJobs
      $scope.mySignUps = $filter('orderBy')($scope.mySignUps, ['signUp.date'])
      $scope.percentComplete = Math.min(100, $scope.complete / $scope.target * 100);


    recalculate()

    $scope.userOptions = [
      {id: 1, fullName: 'Admin Person', admin:true}
      {id: 123, fullName: 'Wendy Three'}
      {id: 42, fullName: 'Ford E. Tou'}
      {id: 456, fullName: 'Bob Dobbs'}
    ]

    $scope.switchUser = (u) ->
      $scope.$emit('su', u)
      recalculate()
    $scope.resetData = ->
      return if !confirm('Are you sure you want to reset? All your changes will be lost')
      $scope.$emit('resetData')
      recalculate()