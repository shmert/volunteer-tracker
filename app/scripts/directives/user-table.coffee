'use strict'

###*
 # @ngdoc directive
 # @name volunteerTrackerHtmlApp.directive:userTable
 # @description
 # # userTable
###
angular.module 'volunteerTrackerHtmlApp'
  .directive 'userTable', ->
    restrict: 'C'
    templateUrl:'views/user-table.html'
    scope:{
      users:'=users'
    }
