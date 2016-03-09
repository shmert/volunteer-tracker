'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminCtrl
 # @description
 # # AdminCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
.controller 'AdminCtrl', ($scope, $location, $http, REST_URL) ->
  $scope.syncingNow = false

  $scope.lastSync = 'Calculating...'

  $scope.add = ->
    $location.path('/job-add')

  $scope.syncWithSchoology = ->
    $scope.syncingNow = true
    $scope.lastSync = 'Syncing now… (you can leave the page and come back)';
    start = new Date()
    $http.get('https://creativeartscharter.org/apps/directory/update-mysql.php', {withCredentials: false}).then(->
      elapsed = new Date().getMilliseconds() - start.getMilliseconds();
      $http.post(REST_URL + '/globals', {lastSchoologySync: start}).then(
        (response) ->
          $scope.lastSync = response.data.lastSchoologySync;
          $scope.syncingNow = false
          $scope.lastSync = start;
          alert('Sync finished in ' + elapsed + "ms")
      )
    , (response) ->
      alert('Sync failed! ' + response.data);
    ).finally ->
      $scope.syncingNow = false

  $http.get(REST_URL + '/globals').then(
    (response) ->
      $scope.lastSync = response.data.lastSchoologySync || '?'
  , (response) ->
    console.log('Cannot get lastSchoologySync: ' + response.data)
  )
