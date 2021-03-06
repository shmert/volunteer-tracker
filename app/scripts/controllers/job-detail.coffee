'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobDetailCtrl
 # @description
 # # JobDetailCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobDetailCtrl', ($scope, $filter, $window, $location, $q, $uibModal, userService, job, jobService, volunteerUtils, session, urlShortener, messageSender) ->
    $scope.job = job
    userId = session.userAccount.id.toString();
    $scope.userId = userId
    $scope.nowString = moment().format('YYYY-MM-DD');
    $scope.showingOldDateOptions = true;

    dateOptionFor = (moment) ->
      formattedDate = moment.format('YYYY-MM-DD')
      signUpsOnDate = _.filter(timeSlot.signUps, (signUp)->signUp.date == formattedDate) for timeSlot in task.timeSlots for task in job
      myStatus = _.findIndex(signUpsOnDate, (signUp)->signUp.userId == userId) != -1
      return {
        date: formattedDate
        dateDisplay: moment.format('MMMM D, YYYY')
        myStatus: myStatus
        registeredCount: signUpsOnDate.length
      }

    $scope.dateOptions = [$scope.job.date]
    if ($scope.job.recurrence?.type && $scope.job.date)
      $scope.showingOldDateOptions = false;
      recur = $scope.job.recurrence
      tmpDate = moment($scope.job.date)
      endDate = if (recur.endDate) then moment(recur.endDate) else tmpDate.clone().add(40, recur.type)
      stepType = recur.type
      stepType = 'day' if recur.type == 'custom-weekly'
      isInRepeatingScheme = ->
        dayOfWeek = tmpDate.day();
        dayOfWeek = 7 if dayOfWeek == 0
        (recur.type != 'custom-weekly' || !recur.daysOfWeek || recur.daysOfWeek[dayOfWeek])
      while ((tmpDate = tmpDate.add(1, stepType)) < endDate)
        if (isInRepeatingScheme())
          $scope.dateOptions.push(tmpDate.format('YYYY-MM-DD'))
      #      ($scope.dateOptions.push(tmpDate.format('YYYY-MM-DD')) if isInRepeatingScheme(tmpDate, recur)) while ((tmpDate = tmpDate.add(1, stepType)) <= endDate)
      exceptions = recur.exceptions?.split(/\s*,\s*/) || []
      _.pull($scope.dateOptions, moment(eachException, 'MM/DD/YYYY').format('YYYY-MM-DD')) for eachException in exceptions

    #$scope.timeSlotGroups = _.groupBy($scope.job.timeSlots, 'name')

    $scope.shouldShowDate = (date) ->
      return $scope.showingOldDateOptions || date >= $scope.nowString;

    # am i signed up for this slot on the currently selected date?
    $scope.myStatus = (slot, date) ->
      return _.findIndex(slot.signUps, (signUp)->signUp.userId == userId && signUp.date == date && !signUp.deleted)

    # How many sign ups for the date
    $scope.slotSignupCount = (slot, date) ->
      signUpsOnDate = _.filter(slot.signUps, (signUp)->signUp.date == date && !signUp.deleted)
      return signUpsOnDate.length

    # what percent complete is this slot on the currently selected date
    $scope.slotCompletePercent = (slot, date, neededOverride) ->
      signUpsOnDate = _.filter(slot.signUps, (signUp)->signUp.date == date && !signUp.deleted)
      return Math.min(100.1, signUpsOnDate.length / (neededOverride || slot.neededMax || slot.needed) * 100)

    $scope.slotCompleted = (slot, date) ->
      return $scope.slotCompletePercent(slot, date, slot.needed) >= 100 # don't use neededMax

    $scope.toggle = (slot, date, optionalMessage) ->
      myIndex = $scope.myStatus(slot, date)
      slot.locked = true
      promise = null;
      if (myIndex != -1)
        return if (!confirm(optionalMessage || 'Are you sure you want to remove yourself for this job?'))
        signUp = slot.signUps[myIndex]
        promise = jobService.updateSignUp({id: signUp.id, deleted: true}).then((updatedSignUp) ->
          slot.signUps.splice(myIndex, 1))
      else
        promise = jobService.updateSignUp({userId: userId, date: date, verified: false, timeSlotId: slot.id}).then (updatedSignUp) ->
          slot.signUps.push(updatedSignUp);
        if (!session.userAccount.phone && session.userAccount.profile_info.phone && !session.userAccount.doNotAskForPhone)
          promise = promise.then ->
            cell = window.prompt('Please provide your cell phone # for other people to contact you')
            if (cell)
              session.userAccount.phone = cell
              userService.updateUser(session.userAccount).then(
                -> alert('Your account has been updated, thanks!'),
                (e) -> session.logAndReportError(e)
              )
      $scope.$emit('save')
      promise.catch((err) ->
        session.logAndReportError(err, 'There was an error while saving your changes, please reload and try again')
      ).finally -> slot.locked = false

    allSignUps = ->
      result = []
      result.push.apply(result, timeSlot.signUps) for timeSlot in task.timeSlots for task in $scope.job.tasks
      return result

    $scope.slotSignUpsOnDate = (slot, date) ->
      signUps = _.filter(slot.signUps, (signUp)->signUp.date == date && !signUp.deleted)

    $scope.composeJobMessage = ->
      allRecipients = _.map(allSignUps(), (s)-> {id: s.userId, fullName: s.fullName})
      composeMessage(allRecipients, $scope.job.name)

    $scope.composeDateMessage = (date) ->
      allRecipients = _.chain(allSignUps()).filter((s)->s.date == date).map((s)-> {id: s.userId, fullName: s.fullName}).value();
      composeMessage(allRecipients, $scope.job.name)

    $scope.composeSingleSignUpMessage = (signUp) ->
      composeMessage([{id: signUp.userId, fullName: signUp.fullName}], $scope.job.name)

    $scope.composeSingleSlotMessage = (slot, eachDate) ->
      signUps = $scope.slotSignUpsOnDate(slot, eachDate)
      recipients = _.map(signUps, (s) -> {id: s.userId, fullName: s.fullName})
      composeMessage(recipients, $scope.job.name)

    composeMessage = (recipients, subject) ->
      if ($scope.apiStatus.status != 'label-success')
        return alert('You must approve API access by clicking the link on the bottom of the page first.');
      recipients = _.uniq(recipients, 'id')
      url = $scope.publicUrl()
      urlPromise = urlShortener.shorten(url, $scope.job.name.replace('[^a-zA-Z0-9]', ''), $scope.job.shortUrl)
      urlPromise.then (shortenedUrl) ->
        $uibModal.open({
          animation: true,
          templateUrl: 'views/message-compose.html',
          controller: 'MessageComposeCtrl',
          size: 'lg',
          resolve: {
            job: $scope.job
            message: {
              subject: subject,
              body: '\n\n\nView the job at ' + shortenedUrl + '',
              recipients: recipients
            }
          }
        }).result
        .then (msg) ->
          recipientIds = _.pluck(msg.recipients, 'id')
          return alert('No recipients were specified') if !recipientIds.length
          payload =
            subject: msg.subject || $scope.job.name
            message: msg.body
            recipient_ids: recipientIds

          messageSender.sendWithFeedback(payload)
        .catch (e) ->
        return typeof e == 'string' # cancel or escape key press most likely
        session.logAndReportError(e, 'Error composing / sending message for ' + $scope.job.name)

    $scope.callPersonWithId = (id) ->
      userService.findById(id).then (response) ->
        user = response;
        alert(user.name_display + ': ' + (user.phone || user.profile_info.phone || '[No phone on file]'))
      , (error) ->
        session.logAndReportError(error, 'Could not locate info for this user')

    $scope.showSignUps = (task, slot, eachDate) ->
      modalInstance = $uibModal.open({
        animation: true,
        templateUrl: 'views/signup-list.html',
        controller: 'SignupListCtrl',
        scope: $scope.$new(false),
  #        size: 'lg',
        resolve: {
          job: $scope.job
          task: task
          whichDate: {date: eachDate} # without wrapping it in an object it tries to find a provider by name
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
      }) for eachDate in dateOptions when ($scope.myStatus(timeSlot, eachDate) != -1) for timeSlot in task.timeSlots for task in $scope.job.tasks
      return alert('Sign up for this job first') if (cal.events.length == 0)
      cal.download(filename);

    $scope.publicUrl = ->
      "https://creativeartscharter.schoology.com/apps/286928878/run/group/49660907?destination=https%3A%2F%2Fapps.creativeartscharter.org%2Fapps%2Fvolunteer%2F%23%2Fjob-detail%2F" + $scope.job.id;

    $scope.showUrl = (shorten) ->
      url = $scope.publicUrl()
      if (shorten)
        urlPromise = urlShortener.shorten(url, $scope.job.name.replace('[^a-zA-Z0-9]', ''), $scope.job.shortUrl)
      else
        urlPromise = $q.resolve(url)
      urlPromise.then (urlToShow) ->
        newScope = $scope.$new(false)
        newScope.job = $scope.job
        newScope.url = urlToShow
        newScope.copy = (text) -> window.clipboard.copy
        $uibModal.open({
          animation: true,
          templateUrl: 'views/modal-url-display.html',
          scope: newScope,
        })

    $scope.viewWithinSchoology = ->
      top.location.href = $scope.publicUrl();

    #    $scope.alreadyViewingWithinSchoology = ->
    #      top.location.href == $scope.publicUrl(); # throws JS exception: Blocked a frame with origin...

    $scope.viewOutsideSchoology = ->
      if(window != top)
        top.location.href = window.location.href

    $scope.alreadyOutsideSchoology = ->
      window == top

    $scope.repeatingDateTime = (date, time) ->
      volunteerUtils.dateTime(moment(date, 'YYYY-MM-DD').toDate(), volunteerUtils.timeParser(time)?.toDate())

    appendExportLine = (data, usersById, task, timeSlot, date) ->
      signUps = $scope.slotSignUpsOnDate(timeSlot, date)
      rowCount = Math.max(signUps.length, timeSlot.needed)
      # i in [1..Math.max($scope.slotSignUpsOnDate(timeSlot, date), timeSlot.needed || 0)] for
      for i in [0..(rowCount-1)]
        signUp = signUps[i] || {}
        data.push(
          [
            task.name
            moment(date).format('MM/DD/YYYY')
            volunteerUtils.timeParser(timeSlot.startTime).format('hh:mm A')
            volunteerUtils.timeParser(timeSlot.endTime).format('hh:mm A')
            '' + (i+1) + ' of ' + rowCount
            usersById[signUp.userId]?.fullName || ''
            usersById[signUp.userId]?.email || ''
            usersById[signUp.userId]?.phone || ''
            signUp.verified || ''
          ]
        )

    $scope.duplicate = ->
      return if (!confirm('Are you sure you want to duplicate this job?'))
      dup = angular.copy($scope.job);
      dup.id = null;
      dup.name += ' Copy';
      dup.date = moment().add(1, 'day').toDate();
      dup.shortUrl = null;
      for t in dup.tasks
        t.id = null;
        t.jobId = null;
        for s in t.timeSlots
          s.id = null;
          s.jobId = null;
          s.signUps = [];
      jobService.push(dup).then((saved) ->
        $location.path('/job-admin/' + saved.id)
      ).catch((err) ->
        session.logAndReportError(err)
      )


    $scope.export = ->
      userService.allUserNames().then (allUsers) ->
        usersById = _.indexBy(allUsers, 'id')
        data = [
          [
            'Task',
            'Date',
            'Start Time',
            'End Time'
            'Position',
            'Volunteer',
            'Email',
            'Phone',
            'Verified',
          ]
        ]
        # FIX! we should iterate over dateOptions also? Only an issue for jobs that aren't fully filled
        appendExportLine(data, usersById, task, timeSlot, date) for timeSlot in task.timeSlots for task in $scope.job.tasks for date in $scope.dateOptions
        content = new CSV(data).encode();
        blob = new Blob([content], {type: 'text/plain;charset=utf-8'});
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
