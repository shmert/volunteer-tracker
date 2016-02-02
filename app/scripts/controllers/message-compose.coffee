'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:MessageComposeCtrl
 # @description
 # # MessageComposeCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
.controller 'MessageComposeCtrl', ($scope, $filter, $q, $uibModalInstance, userService, job, message) ->
  $scope.message = message
  $scope.newRecipient = null

  $scope.send = ->
    return alert('Choose at least one recipient') if $scope.message.recipients.length == 0
    return alert('Please enter required fields') if ($scope.msgForm.$invalid)
    $uibModalInstance.close($scope.message);

  $scope.cancel = ->
    $uibModalInstance.dismiss('cancel');

  $scope.findUsers = (q) ->
    userService.quickSearch(q).then (found) ->
      return found.data

  $scope.queryRecipients = (q) ->
    results = []
    filter = $filter('filter');
    results.push task.name for task in job.tasks when filter(task.name, q)
    return $q.when(results);

  $scope.addRecipient = ->
    $scope.message.recipients.push($scope.newRecipient)
    $scope.newRecipient = null

  return
