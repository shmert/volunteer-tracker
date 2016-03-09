'use strict'

describe 'Directive: jobListDirective', ->

  # load the directive's module
  beforeEach module 'volunteerTrackerHtmlApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<job-list-directive></job-list-directive>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the jobListDirective directive'
