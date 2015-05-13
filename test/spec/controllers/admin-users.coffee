'use strict'

describe 'Controller: AdminUsersCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  AdminUsersCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    #AdminUsersCtrl = $controller 'AdminUsersCtrl', {
    #  $scope: scope
    #}

  it 'should attach a list of awesomeThings to the scope', ->
    #expect(scope.awesomeThings.length).toBe 3
