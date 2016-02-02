'use strict'

describe 'Controller: SignupListCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  SignupListCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SignupListCtrl = $controller 'SignupListCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(SignupListCtrl.awesomeThings.length).toBe 3
