'use strict'

###*
 # @ngdoc directive
 # @name volunteerTrackerHtmlApp.directive:timeField
 # @description
 # # timeField
###
angular.module 'volunteerTrackerHtmlApp'
.directive 'timeField', ($filter) ->
#    restrict: 'EA'
#    template: '<div></div>'
  require: 'ngModel'
  restrict: 'C'
  link: (scope, element, attrs, ctrl) ->
    element.bind('blur', ->
      ctrl.$viewValue = if ctrl.$modelValue then $filter('date') ctrl.$modelValue, 'h:mm a' else ''
      ctrl.$render()
    )
    element.attr('placeholder', 'h:mm') if !element.attr('placeholder')

    ctrl.$parsers.push (data) ->
      if (!data)
        return undefined
      if angular.isDate(data)
        ctrl.$setValidity('date', true)
        return data
      #View -> Model
      # console.log data
      date = moment(data, 'Ha', true)
      date = moment(data, 'H a', true) if !date.isValid()
      date = moment(data, 'H:mm a', true) if !date.isValid()
      if (!date.isValid()) # no AM/PM, interpolate
        date = moment(data, 'H', true)
        date = moment(data, 'H:mm', true) if !date.isValid()
        if (date.hour() < 8)
          date.add('hour', 12)
      #        date = moment(data, 'M/D/YYYY', true) if !date.isValid()
      ctrl.$setValidity 'date', date.isValid()
      if date.isValid()
        return date.toDate()
        # FIX! would be nice to re-format the time on blur
      else undefined
    ctrl.$formatters.push (data) ->
#Model -> View
      $filter('date') data, 'hh:mm a'
    return
