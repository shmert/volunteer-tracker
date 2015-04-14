'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminSignupsCtrl
 # @description
 # # AdminSignupsCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'AdminSignupsCtrl', ($scope, jobService) ->
    $scope.allJobs = jobService.allJobs()
    $scope.timeSlots = []
    #$scope.timeSlots.push(timeSlot) for timeSlot in job.timeSlots for job in jobService.allJobs()

    $scope.percentComplete = ->
      '?'

    $scope.exportJobSignUps =->
      alert('This will export sign up data for all your jobs. Not yet implemented') # FIX!!!
