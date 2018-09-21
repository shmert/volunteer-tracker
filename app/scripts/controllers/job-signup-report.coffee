'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobSignupReportCtrl
 # @description
 # # JobSignupReportCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
.controller 'JobSignupReportCtrl', ($scope, userService, job)->
  $scope.job = job;

  userService.allUserNames().then (allUsers) ->
    usersById = _.indexBy(allUsers, 'id')
    data = []
    data.push([
        task.name
        moment(signUp.date).format('MM/DD/YYYY')
        usersById[signUp.userId]?.fullName
        usersById[signUp.userId]?.email || ''
        usersById[signUp.userId]?.phone || ''
        signUp.verified
        moment(timeSlot.startTime).format('hh:mm A')
        moment(timeSlot.endTime).format('hh:mm A')
      ]
    ) for signUp in timeSlot.signUps for timeSlot in task.timeSlots for task in $scope.job.tasks
    $scope.rows = data

  $scope.visible = [false, true, true, false, true, false, true, true];
  if ($scope.job.tasks.length > 1)
    $scope.visible[0] = true;
  $scope.columns = [
    'Task', 'Date', 'Volunteer', 'Email', 'Phone', 'Verified', 'Start', 'End'
  ]

  return
