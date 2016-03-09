'use strict'

###*
 # @ngdoc directive
 # @name volunteerTrackerHtmlApp.directive:jobListDirective
 # @description
 # # jobListDirective
###
angular.module 'volunteerTrackerHtmlApp'
  .directive 'jobListDirective', ($location, $filter, volunteerUtils) ->
    restrict: 'EA'
    templateUrl: 'views/job-list-directive.html'
    scope:{
      jobs:'=jobs'
    }
    link: (scope, element, attrs) ->
      $scope = scope
      $scope.dateDisplayFor = (job) ->
        if (!job.recurrence || !job.recurrence.type)
          return $filter('date')(job.date)
        else if (job.recurrence.type == 'day')
          return 'Every Day';
        else if (job.recurrence.type == 'week')
          return 'Every ' + moment(job.date).format('dddd')
        else if (job.recurrence.type == 'month')
          return 'Every Month'
        else if (job.recurrence.type == 'custom-weekly')
          return 'Every Week'

      $scope.percentDone = (job) ->
        return volunteerUtils.percentDone(job)

      $scope.showJobDetail = (job) ->
        $location.path('/job-detail/' + job.id)

