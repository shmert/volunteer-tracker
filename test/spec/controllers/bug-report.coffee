'use strict'

describe 'Controller: BugReportCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  BugReportCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BugReportCtrl = $controller 'BugReportCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(BugReportCtrl.awesomeThings.length).toBe 3
