'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminSignupsCtrl
 # @description
 # # AdminSignupsCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'AdminSignupsCtrl', ($scope, $window, jobService, userService, volunteerUtils) ->
    jobService.allJobs({upcoming:false,showPrivate:true}).then((response) -> $scope.allJobs = response.data)
    $scope.timeSlots = []
    #$scope.timeSlots.push(timeSlot) for timeSlot in job.timeSlots for job in jobService.allJobs()

    $scope.percentDone = (job) ->
      return volunteerUtils.percentDone(job);

    $scope.exportJobSignUps =->
      userService.allUserNames().success (allUsers) ->
        usersById = _.indexBy(allUsers, 'id')
        data = [
          [
            'Job',
            'Task',
            'Date',
            'Volunteer',
            'Verified',
            'Start Time',
            'End Time']
        ]
        data.push([
              job.name
              task.name
              moment(signUp.date).format('MM/DD/YYYY')
              usersById[signUp.userId]?.fullName
              signUp.verified
              moment(timeSlot.startTime).format('hh:mm A')
              moment(timeSlot.endTime).format('hh:mm A')
            ]
        ) for signUp in timeSlot.signUps for timeSlot in task.timeSlots for task in job.tasks for job in $scope.allJobs
        content = new CSV(data).encode();
        blob = new Blob([content ], { type: 'text/plain' });
        url = (window.URL || window.webkitURL).createObjectURL(blob, {type: 'text/csv'});

        a = window.document.createElement('a');
        a.href = url
        a.download = 'All_Jobs.csv';

        document.body.appendChild(a)
        a.click()

        document.body.removeChild(a)
        $window.URL.revokeObjectURL(url);