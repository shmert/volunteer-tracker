'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobListCtrl
 # @description
 # # JobListCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobListCtrl', ($scope, $filter, $location, $timeout, jobService, volunteerUtils) ->
    $scope.jobs = null;
    $scope.data = {showAll:$location.search().showAll}


    $scope.fetch = ->
      jobService.allJobs({upcoming:!$scope.data.showAll,filterByCategory:true}).success (jobs)->
        $scope.jobs = jobs;


    $scope.toggleShowAll = ->
      $scope.data.showAll = !$scope.data.showAll;
      $location.search 'showAll', $scope.data.showAll
      $scope.fetch();

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
      return volunteerUtils.percentDone(job)

    $scope.showJobDetail = (job) ->
      $location.path('/job-detail/' + job.id)

    $scope.add = ->
      $location.path('/job-add')

    $scope.notDeletedFilter = (job) -> !job.deleted

    $scope.fetch()