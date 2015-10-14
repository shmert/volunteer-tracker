'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:BugReportCtrl
 # @description
 # # BugReportCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'BugReportCtrl', ($scope, $location, $http, $modal, session, REST_URL) ->
    $scope.sending = false
    $scope.problemReport = {} if !$scope.problemReport
    $scope.problemReport.email = session.userAccount?.primary_email;
    $scope.problemReport.user = session.userAccount?.name_display;
    $scope.problemReport.userId = session.userAccount?.id;
    $scope.problemReport.date = new Date().getTime()
    $scope.cancelUrl = $scope.problemReport.url || '#/'
    $scope.cancelUrl = $scope.cancelUrl.substring($scope.cancelUrl.indexOf('#') + 1)

    $scope.submit = ->
      payload = $scope.problemReport
      $scope.sending = true
      $http.post(REST_URL + '/bug-report', $scope.problemReport).then ->
        alert('Your bug report has been sent!')
        $scope.problemReport = {}
        $location.path($scope.cancelUrl)
      , ->
        alert('Ironically, there was a problem submitting your bug report. Please send an email to sam@360works.com and let me know.')
      .finally ->
        $scope.sending = false;

    $scope.cancel = ->
      $location.path($scope.cancelUrl)

    return
