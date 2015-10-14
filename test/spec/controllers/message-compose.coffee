'use strict'

describe 'Controller: MessageComposeCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  MessageComposeCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MessageComposeCtrl = $controller 'MessageComposeCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(MessageComposeCtrl.awesomeThings.length).toBe 3
