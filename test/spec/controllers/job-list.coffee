'use strict'

describe 'Controller: JobListCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  JobListCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    JobListCtrl = $controller 'JobListCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
