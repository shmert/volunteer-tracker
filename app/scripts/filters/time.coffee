'use strict'

###*
 # @ngdoc filter
 # @name volunteerTrackerHtmlApp.filter:time
 # @function
 # @description
 # # time
 # Filter in the volunteerTrackerHtmlApp.
###
angular.module('volunteerTrackerHtmlApp')
  .filter 'time', (volunteerUtils) ->
    (input) ->
      return '' if not input
      return volunteerUtils.timeParser(input)?.format('h:mm A')

