'use strict'

describe 'Controller: GroupsDetailCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  GroupsDetailCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GroupsDetailCtrl = $controller 'GroupsDetailCtrl', {
      # place here mocked dependencies
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(GroupsDetailCtrl.awesomeThings.length).toBe 3
