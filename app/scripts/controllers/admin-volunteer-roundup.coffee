'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminVolunteerRoundupCtrl
 # @description
 # # AdminVolunteerRoundupCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'AdminVolunteerRoundupCtrl', ($scope, jobService, REST_URL, $http) ->
    $scope.filter = {
      dateFrom:new Date(),
      dateTo:window.moment().add(1, 'year').toDate()
    }
    $scope.jobs = null;
    $scope.selected = {};

    $scope.search = ->
      $scope.jobs = null;
      $scope.filter['categories[]'] = $scope.filter.categories;
      jobService.findByFilter($scope.filter).then(
        (response) =>
          $scope.jobs = response.data
          $scope.selected[j.id] = true for j in $scope.jobs;
        , (error) =>
          window.alert('Could not fetch jobs: ' + error);
      )

    $scope.queryCategories = (q) ->
      url = REST_URL + '/groups'
      url = REST_URL + '/groups-mine-admin' if !$scope.isAdmin()
      $http.get(url, {params:{q:q,},withCredentials:true}).then (response)->
        _.map(response.data, 'title')


    $scope.generate = ->
      $scope.showingGenerated = true;

    $scope.close = ->
      $scope.showingGenerated = false;

    $scope.search();

    return
