'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobAdminCtrl
 # @description
 # # JobAdminCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobAdminCtrl', ($scope, $location, $filter, $http, $uibModal, jobService, job, REST_URL, userService, session, messageSender) ->
    $scope.job = job.data
    $scope.job.date = new Date($scope.job.date) if typeof($scope.job.date) == 'string'
    $scope.job.recurrence.endDate = new Date($scope.job.recurrence.endDate) if typeof($scope.job.recurrence.endDate) == 'string'
    ts.startTime = new Date(ts.startTime) for ts in task.timeSlots for task in $scope.job.tasks
    ts.endTime = new Date(ts.endTime) for ts in task.timeSlots for task in $scope.job.tasks
    userService.allUserNames().success (allUsers) ->
      $scope.allUsers = _.indexBy(allUsers, 'id')


    invalidSummary = (form) ->
      # form.$error.required[0].$name = "Job Name", eg.
      array = '';
      for k, v of form.$error
        name = v[0].$name || 'one or more fields';
        array += (k + ' error ' + name)
      return array

    $scope.addTask = ->
      maxId = 0
      maxId = Math.max(maxId, task.id) for task in $scope.job.tasks
      $scope.job.tasks.push {name:'', description:'', timeSlots:[{needed:1,signUps:[]}]}

    $scope.addSlot = (task) ->
      return alert('Please fix validation errors first: ' + invalidSummary($scope.form)) if $scope.form.$invalid
      task.timeSlots.push({needed:1,signUps:[]})

    $scope.removeSlot = (task, slot) ->
      return if (!confirm('Are you sure you want to remove this shift?'))
      slot.deleted = true;
      undeleted = slot for slot in task.timeSlots when !slot.deleted
      if (!undeleted)
        task.deleted = true

    $scope.peopleFor = (slot) ->
      return "Loading&hellip;" if !$scope.allUsers
      emailOrLink = (user) ->
        return user.fullName if !user.email
        return '<a href="mailto:' + user.email + '">' + user.fullName + '</a>';
      userNames = (emailOrLink($scope.allUsers[s.userId]) for s in slot.signUps);
      return userNames.join(', ')


    $scope.openDatePicker = ($event) ->
      $event.preventDefault();
      $event.stopPropagation();
      $scope.opened = true;

    $scope.datePickerOptions = {
      formatYear: 'yy',
      startingDay: 1
    };

    $scope.dayOfWeekOptions = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];


    $scope.findUsers = (q) ->
      userService.quickSearch(q).then (found) ->
        return found.data

    $scope.didChangeSlotNeeded = (slot) ->
      slot.neededMax = Math.max(slot.neededMax || 0, slot.needed) if slot.neededMax and slot.needed

    $scope.didChangeHrsCredit = (slot) ->
      slot.hrsCredit = $scope.hrsCredit(slot);

    $scope.hrsCredit = (slot) ->
      return slot.hrsCreditOverride || hrsCreditDefault(slot);

    hrsCreditDefault = (slot) ->
      return null if !slot.startTime || !slot.endTime;
      return Math.max(1, slot.endTime.getHours() - slot.startTime.getHours());

    $scope.duplicateSlot = (task, index) ->
      return alert('Please fix validation errors first: ' + invalidSummary($scope.form)) if $scope.form.$invalid
      oldSlot = task.timeSlots[index]
      oldStart = moment(oldSlot.startTime)
      oldEnd = moment(oldSlot.endTime)
      newEnd = oldEnd.add(oldEnd.diff(oldStart)).toDate()
      newSlot = {name:oldSlot.name, needed:oldSlot.needed, neededMax:oldSlot.neededMax, startTime:oldSlot.endTime, endTime:newEnd, hrsCreditOverride:oldSlot.hrsCreditOverride, signUps:[]}
      task.timeSlots.splice(index+1, 0, newSlot)

    $scope.save = ->
      return alert('Please fix validation errors first: ' + invalidSummary($scope.form)) if $scope.form.$invalid
      tasksToSave = task for task in $scope.job.tasks when !task.deleted
      return alert('You must add at least one task') if (!tasksToSave)
      return alert('You must add at least one category') if ($scope.job.categories.length==0)

      task.timeSlots = $filter('orderBy')(task.timeSlots, ['name','startTime']) for task in $scope.job.tasks
      $scope.$emit('save');
      jobService.push($scope.job).then( (saved) ->
        $location.path('/job-detail/' + saved.data.id)
      ).catch( (err) ->
        session.logAndReportError(err)
      )
      #alert('Not saving, because that\'s not implemented yet') #FIX!!!

    $scope.notDeleted = (o) -> !o.deleted

    $scope.delete = ->
      return if !confirm 'Are you sure you want to delete this job?'
      $scope.job.deleted = true #FIX! actually delete it
      $scope.$emit('save');
      jobService.push($scope.job).then( (saved) ->
        $location.path('/job-list')
      ).catch( (err) ->
        session.logAndReportError(err)
      )


    $scope.queryCategories = (q) ->
      url = REST_URL + '/groups'
      url = REST_URL + '/groups-mine-admin' if !$scope.isAdmin()
      $http.get(url, {params:{q:q,},withCredentials:true}).then (response)->
        _.map(response.data, 'title')



