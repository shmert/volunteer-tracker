'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminVolunteerRoundupCtrl
 # @description
 # # AdminVolunteerRoundupCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'AdminVolunteerRoundupCtrl', ($scope, jobService) ->
    $scope.filter = {
      dateFrom:new Date(),
      dateTo:window.moment().add(1, 'year').toDate()
    }
    $scope.jobs = null;
    $scope.selected = {};

    $scope.search = ->
      jobService.findByFilter($scope.filter).then(
        (response) =>
          $scope.jobs = response.data
          $scope.selected[j.id] = true for j in $scope.jobs;
        , (error) =>
          window.alert('Could not fetch jobs: ' + error);
      )

    $scope.generate = ->
      $scope.showingGenerated = true;

    $scope.close = ->
      $scope.showingGenerated = false;

    $scope.search();

    return
