'use strict'

describe 'Controller: SsbCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  SsbCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SsbCtrl = $controller 'SsbCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
