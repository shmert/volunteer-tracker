'use strict'

describe 'Controller: JobDetailCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  JobDetailCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    JobDetailCtrl = $controller 'JobDetailCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
