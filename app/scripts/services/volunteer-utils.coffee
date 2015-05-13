'use strict'

###*
 # @ngdoc service
 # @name volunteerTrackerHtmlApp.volunteerUtils
 # @description
 # # volunteerUtils
 # Value in the volunteerTrackerHtmlApp.
###
angular.module('volunteerTrackerHtmlApp')
.value 'volunteerUtils', {
  percentDone: (job) ->
    signedUp = 0
    needed = 0
    signedUp += slot.signUps.length for slot in task.timeSlots for task in job.tasks
    needed += slot.needed for slot in task.timeSlots for task in job.tasks
    if (job.recurrence?.type)
      occurrences = moment(job.recurrence.endDate).diff(moment(job.date), job.recurrence.type)
      occurrences -= job.recurrence.exceptions.split(',').length if job.recurrence.exceptions
      needed *= occurrences
    return signedUp / needed * 100

  dateTime: (datePart, timePart) ->
    d = moment(@dateFor(datePart))
    t = moment(@dateFor(timePart));
    return moment(d.format('YYYY-MM-DD') + ' ' + t.format('HH:mm:ss'), 'YYYY-MM-DD HH:mm:ss').toDate()

  dateFor: (dateOrString) ->
    return dateOrString if !dateOrString || (angular.isDate(dateOrString))
    return new Date(dateOrString)


  durationOf: (timeSlot) ->
    end = moment(new Date(timeSlot.endTime))
    start = moment(new Date(timeSlot.startTime))
    if (!end.isValid() || !start.isValid())
      console.log('Invalid start/end date in timeSlot ' + timeSlot.id + ': ' + timeSlot.startTime + ' to ' + timeSlot.endTime)
      return 1
    return end.diff(start, 'minutes') / 60

}
