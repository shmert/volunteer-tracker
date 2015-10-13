'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobDetailCtrl
 # @description
 # # JobDetailCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobDetailCtrl', ($scope, $filter, $window, userService, job, jobService, volunteerUtils, session) ->
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

    $scope.dateOptions = [$scope.job.date]
    if ($scope.job.recurrence?.type && $scope.job.date)
      tmpDate = moment($scope.job.date)
      endDate = if ($scope.job.recurrence.endDate) then moment($scope.job.recurrence.endDate) else tmpDate.clone().add(40, $scope.job.recurrence.type)
      $scope.dateOptions.push(tmpDate.format('YYYY-MM-DD')) while ((tmpDate = tmpDate.add(1, $scope.job.recurrence.type)) <= endDate)
      exceptions = $scope.job.recurrence.exceptions?.split(/\s*,\s*/) || []
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

    $scope.toggle = (slot, date) ->
      myIndex = $scope.myStatus(slot, date)
      if (myIndex != -1)
        return if (!confirm('Are you sure you want to remove yourself for this job?'))
        slot.signUps[myIndex].deleted = true
        #slot.signUps.splice(myIndex, 1)
      else
        slot.signUps.push({userId:userId,date:date,verified:false})
      $scope.$emit('save')
      modifiedSlot = jobService.push($scope.job).then( (updatedJob) ->
      ).catch( (err) -> alert('There was an error while saving your changes, please reload and try again'));


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



    $scope.export = ->
      userService.allUserNames().success (allUsers) ->
        usersById = _.indexBy(allUsers, 'id')
        data = [
          [
            'Task',
            'Date',
            'Volunteer',
            'Verified',
            'Start Time',
            'End Time']
        ]
        data.push([
              task.name
              moment(signUp.date).format('MM/DD/YYYY')
              usersById[signUp.userId]?.fullName
              signUp.verified
              moment(timeSlot.startTime).format('hh:mm A')
              moment(timeSlot.endTime).format('hh:mm A')
            ]
        ) for signUp in timeSlot.signUps for timeSlot in task.timeSlots for task in $scope.job.tasks
        content = new CSV(data).encode();
        blob = new Blob([content ], { type: 'text/plain' });
        url = (window.URL || window.webkitURL).createObjectURL(blob, {type: 'text/csv'});

        a = window.document.createElement('a');
        a.href = url
        a.download = $scope.job.name + '.csv';

        document.body.appendChild(a)
        a.click()

        document.body.removeChild(a)
        $window.URL.revokeObjectURL(url);