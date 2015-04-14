'use strict'

describe 'Controller: AdminSignupsCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  AdminSignupsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AdminSignupsCtrl = $controller 'AdminSignupsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
