'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:MessageComposeCtrl
 # @description
 # # MessageComposeCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
.controller 'MessageComposeCtrl', ($scope, $filter, $q, $modalInstance, job, message) ->
  $scope.message = message

  $scope.send = ->
    return alert('Choose at least one recipient group') if $scope.message.recipients.length == 0
    return alert('Please enter required fields') if ($scope.msgForm.$invalid)
    $modalInstance.close($scope.message);

  $scope.cancel = ->
    $modalInstance.dismiss('cancel');

  $scope.queryRecipients = (q) ->
    results = []
    filter = $filter('filter');
    results.push task.name for task in job.tasks when filter(task.name, q)
    return $q.when(results);

  return
