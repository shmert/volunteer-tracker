'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobListCtrl
 # @description
 # # JobListCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobListCtrl', ($scope, $filter, $location, $timeout, session, jobService, volunteerUtils) ->
    $scope.jobs = null;
    $scope.data = {showAll:$location.search().showAll}


    $scope.fetch = ->
      param = {
        upcoming: !$scope.data.showAll,
        filterByCategory: true,
        userId: $location.search().user
      }
      jobService.allJobs(param).success (jobs)->
        $scope.jobs = jobs;


    $scope.toggleShowAll = ->
      $scope.data.showAll = !$scope.data.showAll;
      $location.search 'showAll', $scope.data.showAll
      $scope.fetch();

    $scope.add = ->
      $location.path('/job-add')

    $scope.notDeletedFilter = (job) -> !job.deleted

    $scope.canAddJob = () ->
      $scope.isAdmin() || session.userAccount.adminOfCategories?.length

    $scope.fetch()
