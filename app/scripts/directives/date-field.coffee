'use strict'

###*
 # @ngdoc directive
 # @name volunteerTrackerHtmlApp.directive:dateField
 # @description
 # # dateField
###
angular.module 'volunteerTrackerHtmlApp'
  .directive 'dateField', ($filter) ->
    {
       require: 'ngModel'
       link: (scope, element, attrs, ngModelController) ->
         ngModelController.$parsers.push (data) ->
           #View -> Model
           m = moment(data, 'MM/DD/YYYY')
           date = null;
           date = m.toDate() if m.isValid()
           # if the date field is not a valid date
           # then set a 'date' error flag by calling $setValidity
           ngModelController.$setValidity 'date', !!date
           if date == null then undefined else date
         ngModelController.$formatters.push (data) ->
           #Model -> View
           $filter('date') data, 'MM/dd/yyyy'
         return

     }