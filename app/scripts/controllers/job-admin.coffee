'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobAdminCtrl
 # @description
 # # JobAdminCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobAdminCtrl', ($scope, $location, $filter, $http, $uibModal, jobService, job, REST_URL, userService) ->
    $scope.job = job.data
    $scope.job.date = new Date($scope.job.date) if typeof($scope.job.date) == 'string'
    $scope.job.recurrence.endDate = new Date($scope.job.recurrence.endDate) if typeof($scope.job.recurrence.endDate) == 'string'
    ts.startTime = new Date(ts.startTime) for ts in task.timeSlots for task in $scope.job.tasks
    ts.endTime = new Date(ts.endTime) for ts in task.timeSlots for task in $scope.job.tasks
    userService.allUserNames().success (allUsers) ->
      $scope.allUsers = _.indexBy(allUsers, 'id')


    invalidSummary = (form) ->
      array = '';
      array += (k + ': ' + v) for k, v of form.$error
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

    $scope.didChangeSlotNeeded = (slot) ->
      slot.neededMax = Math.max(slot.neededMax || 0, slot.needed) if slot.neededMax and slot.needed

    $scope.duplicateSlot = (task, index) ->
      return alert('Please fix validation errors first: ' + invalidSummary($scope.form)) if $scope.form.$invalid
      oldSlot = task.timeSlots[index]
      oldStart = moment(oldSlot.startTime, 'H:mm')
      oldEnd = moment(oldSlot.endTime, 'H:mm')
      newEnd = oldEnd.add(oldEnd.diff(oldStart)).format('H:mm')
      newSlot = {name:oldSlot.name, needed:oldSlot.needed, startTime:oldSlot.endTime, endTime:newEnd,signUps:[]}
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
      ).catch( (err) -> alert(err.data) )
      #alert('Not saving, because that\'s not implemented yet') #FIX!!!

    $scope.notDeleted = (o) -> !o.deleted

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


    $scope.composeMessage = ->
      publicUrl = "https://creativeartscharter.schoology.com/apps/286928878/run/group/49660907?destination=https%3A%2F%2Fcreativeartscharter.org%2Fapps%2Fvolunteer%2F%23%2Fjob-detail%2F" + $scope.job.id;
      modalInstance = $uibModal.open({
        animation: true,
        templateUrl: 'views/message-compose.html',
        controller: 'MessageComposeCtrl',
        size: 'lg',
        resolve: {
          job: $scope.job
          message: {subject:$scope.job.name, body:'\n\n\nView the job at <' + publicUrl + '>', recipients:({text:task.name} for task in $scope.job.tasks)}
        }
      }).result.then (msg) ->
        recipientIds = []
        checkedRecipients = _.pluck(msg.recipients, 'text')
        recipientIds.push(signUp.userId) for signUp in timeSlot.signUps for timeSlot in task.timeSlots for task in $scope.job.tasks when checkedRecipients.indexOf(task.name)!=-1
        return alert('No recipients were specified') if !recipientIds.length
        payload =
          subject:msg.subject
          message:msg.body
          recipient_ids:_.uniq(recipientIds)

        $http.post(REST_URL + '/messages', payload).then ->
          alert('Message was sent to ' + recipientIds.length + ' recipient(s)')
        ,(error) ->
          alert('Unable to send your message: ' + error.data);

