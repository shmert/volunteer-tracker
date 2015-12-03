'use strict'

describe 'Controller: GroupsCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  GroupsCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GroupsCtrl = $controller 'GroupsCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(GroupsCtrl.awesomeThings.length).toBe 3
