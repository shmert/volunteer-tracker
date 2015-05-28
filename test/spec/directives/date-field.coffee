'use strict'

describe 'Directive: dateField', ->

  # load the directive's module
  beforeEach module 'volunteerTrackerHtmlApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<date-field></date-field>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the dateField directive'
