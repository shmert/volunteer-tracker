'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:SsbCtrl
 # @description
 # # SsbCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module('volunteerTrackerHtmlApp')
  .controller 'SsbCtrl', ($scope) ->
    $scope.job = {"id":"61","description":"Join us for a casual potluck picnic! Bring yourselves, some food to share and games, balls etc. Stop by any time!\n\nIf you have any trouble with this signup form please contact the office.","name":"All School Family Picnic","date":"2015-08-23T07:00:00.000Z","private":0,"categories":[{"id":"60130981","text":"Mizuho's Third Grade (3A)"},{"id":"64043677","text":"David's Fifth Grade (5A)"}],"tasks":[{"id":"66","name":"Setup","description":"Collect a bin of supplies from school on Friday, bring it to Lindley Meadow and set up around 10:45. Welcome the first families to arrive!","jobId":"61","timeSlots":[{"id":"72","taskId":"66","startTime":"2015-08-18T17:45:00.000Z","endTime":"2015-08-18T18:45:00.000Z","jobId":"61","needed":2,"signUps":[{"id":"125","date":"2015-08-23T07:00:00.000Z","userId":"7562241","verified":0,"timeSlotId":"72"},{"id":"126","date":"2015-08-23T07:00:00.000Z","userId":"7562241","verified":0,"timeSlotId":"72"},{"id":"129","date":"2015-08-23T07:00:00.000Z","userId":"7562241","verified":0,"timeSlotId":"72"}]}]},{"id":"67","name":"Cleanup","description":"Round up helpers to clean up around 4; distribute trash among various families to transport; bring the supplies bin back to school on Monday.","jobId":"61","timeSlots":[{"id":"73","taskId":"67","startTime":"1970-01-02T00:00:00.000Z","endTime":"1970-01-02T01:00:00.000Z","jobId":"61","needed":4,"signUps":[{"id":"127","date":"2015-08-23T07:00:00.000Z","userId":"7562241","verified":0,"timeSlotId":"73"},{"id":"128","date":"2015-08-23T07:00:00.000Z","userId":"7562241","verified":0,"timeSlotId":"73"},{"id":"130","date":"2015-08-23T07:00:00.000Z","userId":"7562241","verified":0,"timeSlotId":"73"}]}]}],"recurrence":{"type":"","endDate":null,"exceptions":null}};