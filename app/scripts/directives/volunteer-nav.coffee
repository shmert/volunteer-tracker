'use strict'

###*
 # @ngdoc directive
 # @name volunteerTrackerHtmlApp.directive:volunteerNav
 # @description
 # # volunteerNav
###
angular.module 'volunteerTrackerHtmlApp'
  .directive 'volunteerNav', ($location) ->
    restrict: 'EAC'
    template: '<div class="header">
        <ul class="nav nav-pills">
            <li ng-class="{active: isActive(\'/\')}"><a href="#/"><i class="fa fa-home"></i> Home</a></li>
            <li ng-class="{active: isActive(\'/job-list\')}"><a href="#/job-list"><i class="fa fa-tasks"></i> Job List</a></li>
            <li ng-class="{active: isActive(\'/admin/addIndividualTime\')}" ng-show="true"><a href="#/admin/addIndividualTime"><i class="fa fa-clock-o"></i> Log Time</a></li>
            <li ng-class="{active: isActive(\'/admin\')}" ng-show="true || isAdminOfAtLeastOneGroup()"><a href="#/admin"><i class="fa fa-pencil"></i> Admin</a></li>
            <li ng-class="{active: isActive(\'/bug-report\')}"><a ng-click="reportProblem()"><i class="fa fa-bug"></i> Report a Problem</a></li>
        </ul>
    </div>'
    link: (scope, element, attrs) ->
