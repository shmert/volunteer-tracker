'use strict'

describe 'Controller: AdminAddindividualtimeCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  AdminAddindividualtimeCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    #AdminAddindividualtimeCtrl = $controller 'AdminAddindividualtimeCtrl', {
    #  $scope: scope
    #}

  it 'should attach a list of awesomeThings to the scope', ->
    #expect(scope.awesomeThings.length).toBe 3
