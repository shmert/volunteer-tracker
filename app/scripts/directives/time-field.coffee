'use strict'

###*
  # Holds internal state as HH:mm (24-hour). Displays to user as 12-hour AM/PM notation.
 # @ngdoc directive
 # @name volunteerTrackerHtmlApp.directive:timeField
 # @description
 # # timeField
###
angular.module 'volunteerTrackerHtmlApp'
	.directive 'timeField', ($filter, volunteerUtils) ->
		{
		require: 'ngModel'
		restrict: 'C'
		scope:{
			min:'=min' # one-way bind
		}
		link: (scope, element, attrs, ngModel) ->
#			element.bind('blur', ->
#				ngModel.$viewValue = if ngModel.$modelValue then moment(ngModel.$modelValue, 'HH:mm').format('h:mm a') else ''
#				ngModel.$render()
#			)
			element.attr('placeholder', 'h:mm') if !element.attr('placeholder')

			ngModel.$parsers.push (data) ->
				if (!data)
					return undefined
				else if angular.isDate(data)
					ngModel.$setValidity('date', true)
					return moment(data).format('HH:mm');
				else if angular.isString(data)
					date = moment(data, 'H a', true)
					date = moment(data, 'H:mm a', true) if !date.isValid()
					if (!date.isValid()) # no AM/PM, interpolate
						date = moment(data, 'H', true)
						date = moment(data, 'H:mm', true) if !date.isValid()
						if (date.hour() < 8)
							date.add(12, 'hour')
					ngModel.$setValidity 'date', date.isValid()
					if date.isValid()
						return date.format('HH:mm')
				else
					undefined
			ngModel.$formatters.push (data) ->
				if (!data)
					return null;
				else
					return volunteerUtils.timeParser(data)?.format('h:mm a');

			ngModel.$validators.min = (value) ->
				return ngModel.$isEmpty(value) || !scope.min || volunteerUtils.timeParser(scope.min)?.toDate() < volunteerUtils.timeParser(value)?.toDate();


			return
		}
