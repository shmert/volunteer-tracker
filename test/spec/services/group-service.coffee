'use strict'

describe 'Service: groupService', ->

  # load the service's module
  beforeEach module 'volunteerTrackerHtmlApp'

  # instantiate service
  groupService = {}
  beforeEach inject (_groupService_) ->
    groupService = _groupService_

  it 'should do something', ->
    expect(!!groupService).toBe true
