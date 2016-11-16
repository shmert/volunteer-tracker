'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminCtrl
 # @description
 # # AdminCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
.controller 'AdminCtrl', ($scope, $location, $http, REST_URL, session) ->
  $scope.syncingNow = false
  $scope.myUserId = session.userAccount.id;

  $scope.lastSync = 'Calculating...'


  $scope.add = ->
    $location.path('/job-add')

  $scope.errorTest = ->
    $http.get(REST_URL + '/error-test').then(
      (response) -> window.alert('Got a valid response: ' + response),
      (error) -> window.alert('Got an error: ' + error);
    )

  $scope.syncWithSchoology = ->
    $scope.syncingNow = true
    $scope.lastSync = 'Syncing now… (you can leave the page and come back)';
    start = new Date()
    $http.get('https://apps.creativeartscharter.org/apps/update-mysql.php', {withCredentials: false}).then(->
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
      $scope.lastSync = moment(new Date(response.data.lastSchoologySync)).format("dddd, MMMM Do YYYY, h:mm:ss a") || '?'
  , (response) ->
    console.log('Cannot get lastSchoologySync: ' + response.data)
  )


