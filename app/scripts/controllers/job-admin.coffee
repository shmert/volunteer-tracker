'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobAdminCtrl
 # @description
 # # JobAdminCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobAdminCtrl', ($scope, $location, $filter, $http, jobService, job, REST_URL) ->
    $scope.job = job.data
    $scope.job.date = new Date($scope.job.date) if typeof($scope.job.date) == 'string'
    $scope.job.recurrence.endDate = new Date($scope.job.recurrence.endDate) if typeof($scope.job.recurrence.endDate) == 'string'
    ts.startTime = new Date(ts.startTime) for ts in task.timeSlots for task in $scope.job.tasks
    ts.endTime = new Date(ts.endTime) for ts in task.timeSlots for task in $scope.job.tasks

    $scope.addTask = ->
      maxId = 0
      maxId = Math.max(maxId, task.id) for task in $scope.job.tasks
      $scope.job.tasks.push {name:'', description:'', timeSlots:[{needed:1,signUps:[]}]}

    $scope.addSlot = (task) ->
      return alert('Please fix validation errors first') if $scope.form.$invalid
      task.timeSlots.push({needed:1,signUps:[]})

    $scope.removeSlot = (task, slot) ->
      return if (!confirm('Are you sure you want to remove this slot?'))
      slot.deleted = true;
      undeleted = slot for slot in task.timeSlots when !slot.deleted
      if (!undeleted)
        task.deleted = true

    $scope.openDatePicker = ($event) ->
      $event.preventDefault();
      $event.stopPropagation();
      $scope.opened = true;

    $scope.datePickerOptions = {
      formatYear: 'yy',
      startingDay: 1
    };

    $scope.duplicateSlot = (task, index) ->
      return alert('Please fix validation errors first') if $scope.form.$invalid
      oldSlot = task.timeSlots[index]
      oldStart = moment(oldSlot.startTime, 'H:mm')
      oldEnd = moment(oldSlot.endTime, 'H:mm')
      newEnd = oldEnd.add(oldEnd.diff(oldStart)).format('H:mm')
      newSlot = {name:oldSlot.name, needed:oldSlot.needed, startTime:oldSlot.endTime, endTime:newEnd,signUps:[]}
      task.timeSlots.splice(index+1, 0, newSlot)

    $scope.save = ->
      tasksToSave = task for task in $scope.job.tasks when !task.deleted
      return alert('You must add at least one task') if (!tasksToSave)
      return alert('You must add at least one category') if ($scope.job.categories.length==0)

      task.timeSlots = $filter('orderBy')(task.timeSlots, ['name','startTime']) for task in $scope.job.tasks
      $scope.$emit('save');
      jobService.push($scope.job).then( (saved) ->
        $location.path('/job-detail/' + saved.data.id)
      ).catch( (err) -> alert(err.data) )
      #alert('Not saving, because that\'s not implemented yet') #FIX!!!

    $scope.delete = ->
      return if !confirm 'Are you sure you want to delete this job?'
      $scope.job.deleted = true #FIX! actually delete it
      $scope.$emit('save');
      jobService.push($scope.job).then( (saved) ->
        $location.path('/job-list')
      ).catch( (err) -> alert(err.data) )


    $scope.queryCategories = (q) ->
      url = REST_URL + '/groups'
      url = REST_URL + '/groups-mine' if !$scope.isAdmin()
      $http.get(url, {params:{q:q,},withCredentials:true}).then (response)-> _.map(response.data, 'title')

