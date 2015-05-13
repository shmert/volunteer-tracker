'use strict'

describe 'Controller: JobdetailCtrl', ->

  # load the controller's module
  beforeEach module 'volunteerTrackerHtmlApp'

  JobdetailCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    #JobdetailCtrl = $controller 'JobdetailCtrl', {
    #  $scope: scope
    #}

  it 'should attach a list of awesomeThings to the scope', ->
    #expect(scope.awesomeThings.length).toBe 3
