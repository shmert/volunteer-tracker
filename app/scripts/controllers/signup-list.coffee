'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:SignupListCtrl
 # @description
 # # SignupListCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'SignupListCtrl', ($scope, $uibModalInstance, session, userService, jobService, job, task, slot, whichDate) ->
    $scope.task = task
    $scope.slot = slot
    date = whichDate.date
    $scope.date = date;
    userService.allUserNames().success (allUsers) ->
      $scope.allUsers = _.indexBy(allUsers, 'id')


    signUps = _.filter(slot.signUps, (signUp)->signUp.date==date && !signUp.deleted)
    needed = Math.max(slot.needed, slot.neededMax);
    $scope.rows = []
    $scope.rows[i] = {signUp:signUps[i]} for i in [0..(needed-1)]

    $scope.findUsers = (q) ->
      config = {}
      config.linkedTo = session.userAccount.id if !$scope.isAdminForJob($scope.job)
      userService.quickSearch(q, config).then (found) ->
        return found.data

    $scope.newSignUp = (row) ->
      newUser = row.newUser
      promise = jobService.updateSignUp({userId:newUser.id,date:date,verified:false, timeSlotId:slot.id}).then (updatedSignUp) ->
        slot.signUps.push(updatedSignUp.data);
        row.signUp = updatedSignUp.data;
        row.newUser = null;

    $scope.canRemove = (signUp) ->
      return false if !signUp;
      return $scope.isAdminForJob($scope.job) ||
          signUp.userId.toString() == session.userAccount.id.toString() ||
          session.userAccount.linkedUsers[signUp.userId];

    $scope.clearRow = (row) ->
      slot.locked = true
      promise = null;
      return if (!confirm('Are you sure you want to remove ' + row.signUp.fullName + ' from this job?'))
      signUp = row.signUp;
      myIndex = slot.signUps.indexOf(signUp);
      promise = jobService.updateSignUp({id:signUp.id, deleted:true}).then( (updatedSignUp) ->
        row.signUp = null;
        slot.signUps.splice(myIndex, 1))
      .finally ->
        slot.locked = false

    $scope.cancel =->
      $uibModalInstance.dismiss('cancel');

