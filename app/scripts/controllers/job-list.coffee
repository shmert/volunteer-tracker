'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobListCtrl
 # @description
 # # JobListCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobListCtrl', ($scope, $filter, $location, jobs) ->
    $scope.jobs = jobs

    $scope.dateDisplayFor = (job) ->
      if (!job.recurrence || !job.recurrence.type)
        return $filter('date')(job.date)
      else if (job.recurrence.type == 'day')
        return 'Every Day';
      else if (job.recurrence.type == 'week')
        return 'Every ' + moment(job.date).format('dddd')
      else if (job.recurrence.type == 'month')
        return 'Every Month'

    $scope.percentDone = (job) ->
      signedUp = 0
      needed = 0
      signedUp += slot.signUps.length for slot in job.timeSlots
      needed += slot.needed for slot in job.timeSlots
      if (job.recurrence?.type)
        occurrences = moment(job.recurrence.endDate).diff(moment(job.date), job.recurrence.type)
        occurrences -= job.recurrence.exceptions.split(',').length if job.recurrence.exceptions
        needed *= occurrences
      return signedUp / needed * 100

    $scope.showJobDetail = (job) ->
      $location.path('/job-detail/' + job.id)

    $scope.add = ->
      $location.path('/job-add')

    $scope.notDeletedFilter = (job) -> !job.deleted