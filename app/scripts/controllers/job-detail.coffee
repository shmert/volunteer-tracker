'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:JobDetailCtrl
 # @description
 # # JobDetailCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'JobDetailCtrl', ($scope, $filter, job) ->
    $scope.job = job
    userId = $scope.user.id;

    dateOptionFor = (moment) ->
      formattedDate = moment.format('YYYY-MM-DD')
      signUpsOnDate = _.filter(timeSlot.signUps, (signUp)->signUp.date==formattedDate) for timeSlot in job.timeSlots
      myStatus = _.findIndex(signUpsOnDate, (signUp)->signUp.userId==userId) != -1
      return {
        date:formattedDate
        dateDisplay:moment.format('MMMM D, YYYY')
        myStatus: myStatus
        registeredCount:signUpsOnDate.length
      }

    $scope.dateOptions = []
    if (job.recurrence?.type && job.date)
      tmpDate = moment($scope.job.date)
      endDate = if ($scope.job.recurrence.endDate) then moment($scope.job.recurrence.endDate) else tmpDate.clone().add(40, job.recurrence.type)
      $scope.dateOptions.push(tmpDate.format('YYYY-MM-DD')) while ((tmpDate = tmpDate.add(1, job.recurrence.type)) <= endDate)
      exceptions = job.recurrence.exceptions?.split(/\s*,\s*/) || []
      _.pull($scope.dateOptions, moment(eachException, 'MM/DD/YYYY').format('YYYY-MM-DD')) for eachException in exceptions
    else
      $scope.dateOptions = [job.date]

    $scope.timeSlotGroups = _.groupBy(job.timeSlots, 'name')

    # am i signed up for this slot on the currently selected date?
    $scope.myStatus = (slot, date) ->
      return _.findIndex(slot.signUps, (signUp)->signUp.userId==userId && signUp.date==date)

    # How many sign ups for the date
    $scope.slotSignupCount = (slot, date) ->
      signUpsOnDate = _.filter(slot.signUps, (signUp)->signUp.date==date)
      return signUpsOnDate.length

    # what percent complete is this slot on the currently selected date
    $scope.slotCompletePercent = (slot, date) ->
      signUpsOnDate = _.filter(slot.signUps, (signUp)->signUp.date==date)
      return signUpsOnDate.length / slot.needed * 100

    $scope.slotCompleted = (slot, date) ->
      return $scope.slotCompletePercent(slot, date) >= 100

    $scope.toggle = (slot, date) ->
      myIndex = $scope.myStatus(slot, date)
      if (myIndex != -1)
        return if (!confirm('Are you sure you want to remove yourself for this job?'))
        slot.signUps.splice(myIndex, 1)
      else
        slot.signUps.push({userId:userId,date:date,verified:false})
      $scope.$emit('save')


