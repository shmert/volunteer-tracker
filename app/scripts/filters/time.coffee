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
  .filter 'time', ->
    (input) ->
      return '' if not input
      return moment(input, 'H:mm').format('h:mm A')

