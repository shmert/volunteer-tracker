'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:VolunteerappctrlCtrl
 # @description
 # # VolunteerappctrlCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'VolunteerAppCtrl', ($scope, session, $location, $http, REST_URL) ->
    $scope.loggedIn = false;
    $scope.$on('loggedIn', (loggedIn) ->
      $scope.loggedIn = loggedIn
      console.log('Showing main app content') if (loggedIn)
    )

    $scope.apiStatus = {status:'label-warning', msg:'Checking Schoology API status...'};

    $scope.isAdmin =-> session.schoologyAccount.admin

    $scope.isAdminOfAtLeastOneGroup =-> $scope.isAdmin() || session.userAccount.adminOfCategories.length;

    $scope.backupSchoologyAccount =-> session.schoologyAccountBackup

    $scope.isActive = (path) ->
      return true if (path == '/' && $location.path() == '/');
      return path == $location.path()

    $scope.isAdminForJob = (job) ->
      return true if $scope.isAdmin()
      userCategories = _.values(session.userAccount.adminOfCategories)
      jobCategories = _.map(job.categories, 'id')
      return _.intersection(userCategories, jobCategories ).length != 0

    $scope.reportProblem = ->
      $scope.problemReport = {
        url: window.location.href
        userAgent: window.navigator.userAgent
        notes: ''
      }
      $location.path('bug-report')

    $http.get(REST_URL + '/api-test').then(
      (response) ->
        $scope.apiStatus = {status:'label-success', msg:'Schoology API connection is OK'};
      , (response) ->
        $scope.apiStatus = {status:'label-danger', msg:'Schoology API connection is not authorized! '};
        if response.status == -1
          window.console.log('Schoology API is not working correctly.');
#          window.location.href = REST_URL + '/check-api-authorization?app_url=' + encodeURIComponent(window.location.href)
    )
