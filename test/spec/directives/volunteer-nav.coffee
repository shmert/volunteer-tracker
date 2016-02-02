'use strict'

describe 'Directive: volunteerNav', ->

  # load the directive's module
  beforeEach module 'volunteerTrackerHtmlApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<volunteer-nav></volunteer-nav>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the volunteerNav directive'
