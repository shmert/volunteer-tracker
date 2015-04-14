'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminAddindividualtimeCtrl
 # @description
 # # AdminAddindividualtimeCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
.controller 'AdminAddindividualtimeCtrl', ($scope, users, jobService, $location) ->
  $scope.userOptions = users

  $scope.job = {
    volunteers: [
      {user: null}
    ]
  }

  $scope.ensureEmptyVolunteerSlotExists = ->
    if ($scope.job.volunteers.length == 0 || $scope.job.volunteers[$scope.job.volunteers.length - 1].user != null)
      $scope.job.volunteers.push({user: null})

  $scope.removeVolunteer = ($index) ->
    $scope.job.volunteers.splice($index, 1)
    $scope.ensureEmptyVolunteerSlotExists()

  $scope.save = ->

    signUps = _.map( $scope.job.volunteers, (v)->{userId:v.user?.id, date:$scope.job.date, verified:true})
    signUps.pop()

    return alert('Please choose at least one volunteer') if signUps.length == 0

    endTime = moment('8:00:00', 'HH:mm:ss').add($scope.job.hours, 'h').format('HH:mm:ss')

    newTaskId = Math.random()

    newJob = {
      id: null,
      name: $scope.job.description,
      date: $scope.job.date,
      private:true
      categories: [],
      recurrence: {type: ''},
      tasks: [
        {id: newTaskId, name: $scope.job.description, description: 'One-off job item'}
      ]
      timeSlots: [
        {
          signUps:signUps
          needed:signUps.length
          startTime:'8:00:00'
          endTime:endTime
          taskId:newTaskId # FIX!!! how to get this before it has an ID? Do we assign a UUID ourselves? Inline a reference?
        }
      ]

    }
    jobService.push(newJob)
    $location.path('/admin')

  $scope.jobCount = ->
    return jobService.allJobs().length
