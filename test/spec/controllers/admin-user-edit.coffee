'use strict'

describe 'Controller: AdminUserEditCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  AdminUserEditCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AdminUserEditCtrl = $controller 'AdminUserEditCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
