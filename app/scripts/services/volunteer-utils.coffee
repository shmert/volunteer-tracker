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
  durationOf: (timeSlot) ->
    end = moment(timeSlot.endTime, 'H:mm')
    start = moment(timeSlot.startTime, 'H:mm')
    return 1 if !end.isValid() || !start.isValid
    return end.diff(start, 'minutes') / 60

}
