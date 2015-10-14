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
    restrict: 'C'
    link: (scope, element, attrs, ctrl) ->
      element.bind('blur', ->
        ctrl.$viewValue = if ctrl.$modelValue then $filter('date') ctrl.$modelValue, 'M/dd/yyyy' else ''
        ctrl.$render()
      )

      ctrl.$parsers.push (data) ->
        if (!data)
          return undefined
        if angular.isDate(data)
          ctrl.$setValidity('date', true)
          return data
        #View -> Model
        # console.log data
        date = moment(data, 'M/D/YY', true)
        date = moment(data, 'M/D/YYYY', true) if !date.isValid()
        date = moment(data, 'M/D', true) if !date.isValid()
        if (date.isValid())
          if (date.year() == 0 || date.year() == 2015)
            date.year(moment().year())
          else if (date.year() < 100)
            date.add(2000, 'year')
          else if (date.year() < 2000)
            date = moment('') # invalid
        ctrl.$setValidity 'date', date.isValid()
        if date.isValid() then date.toDate() else undefined
      ctrl.$formatters.push (data) ->
        #Model -> View
        $filter('date') data, 'M/dd/yyyy'
      return

     }
