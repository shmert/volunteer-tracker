'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobAdminCtrl
 # @description
 # # JobAdminCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobAdminCtrl', ($scope, $location, $filter, job) ->
    $scope.job = job

    $scope.addSlot =->
      return alert('Please fix validation errors first') if $scope.form.$invalid
      $scope.job.timeSlots.push({needed:1,signUps:[]})

    $scope.removeSlot = (index) ->
      return if (!confirm('Are you sure you want to remove this slot?'))
      $scope.job.timeSlots.splice(index, 1)

    $scope.duplicateSlot = (index) ->
      return alert('Please fix validation errors first') if $scope.form.$invalid
      oldSlot = job.timeSlots[index]
      oldStart = moment(oldSlot.startTime, 'H:mm')
      oldEnd = moment(oldSlot.endTime, 'H:mm')
      newEnd = oldEnd.add(oldEnd.diff(oldStart)).format('H:mm')
      newSlot = {name:oldSlot.name, needed:oldSlot.needed, startTime:oldSlot.endTime, endTime:newEnd,signUps:[]}
      $scope.job.timeSlots.splice(index+1, 0, newSlot)

    $scope.save = ->
      $scope.job.timeSlots = $filter('orderBy')($scope.job.timeSlots, ['name','startTime'])
      $scope.$emit('save');
      #alert('Not saving, because that\'s not implemented yet') #FIX!!!
      $location.path('/job-detail/' + $scope.job.id)

    $scope.delete = ->
      return if !confirm 'Are you sure you want to delete this job?'
      $scope.job.deleted = true #FIX! actually delete it
      $scope.$emit('save');
      $location.path('/job-list')