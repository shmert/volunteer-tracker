'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobDetailCtrl
 # @description
 # # JobDetailCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobDetailCtrl', ($scope, $filter, $window, $uibModal, userService, job, jobService, volunteerUtils, session) ->
    $scope.job = job.data
    userId = session.userAccount.id.toString();

    dateOptionFor = (moment) ->
      formattedDate = moment.format('YYYY-MM-DD')
      signUpsOnDate = _.filter(timeSlot.signUps, (signUp)->signUp.date==formattedDate) for timeSlot in task.timeSlots for task in job
      myStatus = _.findIndex(signUpsOnDate, (signUp)->signUp.userId==userId) != -1
      return {
        date:formattedDate
        dateDisplay:moment.format('MMMM D, YYYY')
        myStatus: myStatus
        registeredCount:signUpsOnDate.length
      }

    isInRepeatingScheme = (tmpDate) ->
      dayOfWeek = tmpDate.day();
      dayOfWeek = 7 if dayOfWeek == 0
      (recur.type!='custom-weekly' || !recur.daysOfWeek || recur.daysOfWeek[dayOfWeek])

    $scope.dateOptions = [$scope.job.date]
    if ($scope.job.recurrence?.type && $scope.job.date)
      recur = $scope.job.recurrence
      tmpDate = moment($scope.job.date)
      endDate = if (recur.endDate) then moment(recur.endDate) else tmpDate.clone().add(40, recur.type)
      stepType = recur.type
      stepType = 'day' if recur.type == 'custom-weekly'
      ($scope.dateOptions.push(tmpDate.format('YYYY-MM-DD')) if isInRepeatingScheme(tmpDate)) while ((tmpDate = tmpDate.add(1, stepType)) <= endDate)
      exceptions = recur.exceptions?.split(/\s*,\s*/) || []
      _.pull($scope.dateOptions, moment(eachException, 'MM/DD/YYYY').format('YYYY-MM-DD')) for eachException in exceptions

    #$scope.timeSlotGroups = _.groupBy($scope.job.timeSlots, 'name')

    # am i signed up for this slot on the currently selected date?
    $scope.myStatus = (slot, date) ->
      return _.findIndex(slot.signUps, (signUp)->signUp.userId==userId && signUp.date==date && !signUp.deleted)

    # How many sign ups for the date
    $scope.slotSignupCount = (slot, date) ->
      signUpsOnDate = _.filter(slot.signUps, (signUp)->signUp.date==date && !signUp.deleted)
      return signUpsOnDate.length

    # what percent complete is this slot on the currently selected date
    $scope.slotCompletePercent = (slot, date) ->
      signUpsOnDate = _.filter(slot.signUps, (signUp)->signUp.date==date && !signUp.deleted)
      return Math.min(100.1, signUpsOnDate.length / slot.needed * 100)

    $scope.slotCompleted = (slot, date) ->
      return $scope.slotCompletePercent(slot, date) >= 100

    $scope.toggle = (slot, date, optionalMessage) ->
      myIndex = $scope.myStatus(slot, date)
      slot.locked = true
      promise = null;
      if (myIndex != -1)
        return if (!confirm(optionalMessage || 'Are you sure you want to remove yourself for this job?'))
        signUp = slot.signUps[myIndex]
        promise = jobService.updateSignUp({id:signUp.id, deleted:true}).then( (updatedSignUp) ->
          slot.signUps.splice(myIndex, 1))
      else
        promise = jobService.updateSignUp({userId:userId,date:date,verified:false, timeSlotId:slot.id}).then (updatedSignUp) ->
          slot.signUps.push(updatedSignUp.data);
      $scope.$emit('save')
      promise.catch( (err) -> alert('There was an error while saving your changes, please reload and try again'))
      .finally -> slot.locked = false

    $scope.slotSignUpsOnDate = (slot, date) ->
      signUps = _.filter(slot.signUps, (signUp)->signUp.date==date && !signUp.deleted)

    $scope.showSignUps = (task, slot, eachDate) ->
      modalInstance = $uibModal.open({
        animation: true,
        templateUrl: 'views/signup-list.html',
        controller: 'SignupListCtrl',
        scope:$scope.$new(false),
#        size: 'lg',
        resolve: {
          job: $scope.job
          task: task
          whichDate: {date:eachDate} # without wrapping it in an object it tries to find a provider by name
          slot: slot
        }
      })
    $scope.downloadIcs = ->
      job = $scope.job
      filename = $scope.job.name + 'ics'
      dateOptions = $scope.dateOptions
      cal = new ICS("360Works//VolunteerTracker")
      cal.addEvent({
          UID: 'vt' + job.id + task.id + timeSlot.id + eachDate
          DTSTART: volunteerUtils.dateTime(eachDate, timeSlot.startTime),
          DTEND: volunteerUtils.dateTime(eachDate, timeSlot.endTime),
          SUMMARY: job.name,
          DESCRIPTION: (task.name + '\n' + task.description).replace('\n', '\\n'),
          LOCATION: "",
          ORGANIZER: "",
          URL: window.location.href,
          #EXDATE: ICSFormatDate(new Date().getTime() - 1200000)+","+ICSFormatDate(new Date().getTime() + 4800000),
          #RRULE: "FREQ=WEEKLY;UNTIL="+ICSFormatDate(new Date().getTime() + 3600000)
      }) for eachDate in dateOptions when ($scope.myStatus(timeSlot, eachDate)!=-1) for timeSlot in task.timeSlots for task in $scope.job.tasks
      return alert('Sign up for this job first') if (cal.events.length == 0)
      cal.download(filename);

    $scope.publicUrl = ->
      "https://creativeartscharter.schoology.com/apps/286928878/run/group/49660907?destination=https%3A%2F%2Fcreativeartscharter.org%2Fapps%2Fvolunteer%2F%23%2Fjob-detail%2F" + $scope.job.id;

    $scope.viewWithinSchoology = ->
      top.location.href = $scope.publicUrl();

    $scope.alreadyViewingWithinSchoology = ->
      top.location.href == $scope.publicUrl();

    $scope.viewOutsideSchoology = ->
      if(window != top)
        top.location.href = window.location.href

    $scope.alreadyOutsideSchoology = ->
      window == top

    $scope.repeatingDateTime = (date, time) ->
      volunteerUtils.dateTime(moment(date,'YYYY-MM-DD').toDate(), moment(time).toDate())

    $scope.export = ->
      userService.allUserNames().success (allUsers) ->
        usersById = _.indexBy(allUsers, 'id')
        data = [
          [
            'Task',
            'Date',
            'Volunteer',
            'Email',
            'Verified',
            'Start Time',
            'End Time']
        ]
        data.push([
              task.name
              moment(signUp.date).format('MM/DD/YYYY')
              usersById[signUp.userId]?.fullName
              usersById[signUp.userId]?.email
              signUp.verified
              moment(timeSlot.startTime).format('hh:mm A')
              moment(timeSlot.endTime).format('hh:mm A')
            ]
        ) for signUp in timeSlot.signUps for timeSlot in task.timeSlots for task in $scope.job.tasks
        content = new CSV(data).encode();
        blob = new Blob([content ], { type: 'text/plain;charset=utf-8' });
#        url = (window.URL || window.webkitURL).createObjectURL(blob, {type: 'text/csv'});

        saveAs(blob, $scope.job.name + ".csv");

#        a = window.document.createElement('a');
#        a.href = url
#        a.download = $scope.job.name + '.csv';
#
#        document.body.appendChild(a)
#        a.click()
#
#        document.body.removeChild(a)
#        $window.URL.revokeObjectURL(url);
