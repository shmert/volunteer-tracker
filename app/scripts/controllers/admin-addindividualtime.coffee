'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminAddindividualtimeCtrl
 # @description
 # # AdminAddindividualtimeCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
.controller 'AdminAddindividualtimeCtrl', ($scope, userService, users, jobService, $location, $q) ->
  $scope.userOptions = users

  $scope.job = {
    volunteers: [
      {user: null}
    ]
  }

  $scope.findUsers = (q) ->
    userService.quickSearch(q).then (found) ->
      return found.data

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

    startTime = moment('8:00:00', 'HH:mm:ss').toDate()
    endTime = moment('8:00:00', 'HH:mm:ss').add($scope.job.hours, 'h').toDate()


    newJob = {
      id: null,
      name: $scope.job.description,
      date: $scope.job.date,
      private:true
      categories: [],
      recurrence: {type: '',daysOfWeek:{1:true,2:true,3:true,4:true,5:true}},
      tasks: [
        {
          id: null,
          name: $scope.job.description,
          description: 'One-off job item'
          timeSlots: [
            {
              signUps:signUps
              needed:signUps.length
              startTime:startTime
              endTime:endTime
            }
          ]

        }
      ]

    }
    jobService.push(newJob)
    $location.path('/admin')

  $scope.jobCount = ->
    return jobService.allJobs().length
